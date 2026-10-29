import Foundation
import Observation
import Translation

@MainActor
@Observable
final class TranslatorViewModel {
    enum Phase: Equatable {
        case idle
        case listening
        case transcribing
        case translating
        case speaking
        case downloading
        case error(String)

        var label: String {
            switch self {
            case .idle: "Ready"
            case .listening: "Listening…"
            case .transcribing: "Transcribing…"
            case .translating: "Translating…"
            case .speaking: "Speaking"
            case .downloading: "Downloading languages…"
            case .error(let message): "Error: \(message)"
            }
        }

        var isBusy: Bool {
            switch self {
            case .idle, .error: false
            default: true
            }
        }
    }

    var source: AppLanguage = .english { didSet { languagesChanged() } }
    var target: AppLanguage = .spanish { didSet { languagesChanged() } }
    var draft = ""
    var phase: Phase = .idle
    var turns: [Turn] = []
    var languageStatus: LanguageStatus = .checking
    /// Set to trigger `.translationTask` in the view. This is required to
    /// download language packs and is also the supported translation route on
    /// iOS 18 through iOS 25.
    var translationConfiguration: TranslationSession.Configuration?
    var autoSpeak = true
    /// The most recent speech transcript, shown even if translation fails.
    var lastHeard: String?
    /// Conversation content is intentionally in-memory only. The handoff preview
    /// disappears with the conversation and is never synced or exported by the app.
    var handoffExpiresAt: Date?

    let retentionInterval: TimeInterval

    private let transcriber: Transcriber
    private let translator: Translator
    private let speaker = Speaker()
    private let capture = AudioCapture()
    private var expiryTask: Task<Void, Never>?
    private var translationTaskAction: TranslationTaskAction?

    private enum TranslationTaskAction {
        case download
        case translate(PendingTranslation)
    }

    private struct PendingTranslation {
        let text: String
        let source: AppLanguage
        let target: AppLanguage
        let viaSpeech: Bool
    }

    init(
        transcriber: Transcriber = AppleSpeechTranscriber(),
        translator: Translator = OnDeviceTranslator(),
        retentionInterval: TimeInterval = TranslatorViewModel.retentionIntervalFromLaunchArguments()
    ) {
        self.transcriber = transcriber
        self.translator = translator
        self.retentionInterval = retentionInterval
    }

    // MARK: - Languages

    func swapLanguages() {
        let oldSource = source
        source = target
        target = oldSource
    }

    func refreshStatus() async {
        languageStatus = .checking
        languageStatus = await translator.status(from: source, to: target)
    }

    func prepareOffline() {
        phase = .downloading
        startTranslationTask(for: .download, source: source, target: target)
    }

    /// Called from `.translationTask` with a system-authorized session. It
    /// owns downloads on every supported OS and translation before iOS 26.
    func runTranslationTask(with session: TranslationSession) async {
        guard let action = translationTaskAction else { return }
        translationTaskAction = nil

        switch action {
        case .download:
            await downloadLanguages(with: session)
        case .translate(let request):
            await translate(request, with: session)
        }
    }

    private func downloadLanguages(with session: TranslationSession) async {
        do {
            try await session.prepareTranslation()
            phase = .idle
        } catch {
            phase = .error("Couldn't download \(source.name) → \(target.name). \(error.localizedDescription)")
        }
        await refreshStatus()
    }

    private func languagesChanged() {
        Task { await refreshStatus() }
    }

    // MARK: - Typed input

    func translateDraft() async {
        let text = draft.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !text.isEmpty, !phase.isBusy else { return }
        draft = ""
        await translateAndAppend(text, viaSpeech: false)
    }

    // MARK: - Speech input

    var isListening: Bool { phase == .listening }

    func toggleListening() async {
        if isListening {
            await stopListening()
        } else {
            await startListening()
        }
    }

    private func startListening() async {
        guard !phase.isBusy else { return }
        guard await AudioCapture.requestPermission() else {
            phase = .error("Microphone access is off. Turn it on in Settings.")
            return
        }
        guard await AppleSpeechTranscriber.requestAuthorization() else {
            phase = .error("Speech recognition is off. Turn it on in Settings.")
            return
        }
        speaker.stop()
        do {
            try capture.start()
            phase = .listening
        } catch {
            phase = .error("Couldn't start the microphone.")
        }
    }

    private func stopListening() async {
        guard let url = capture.stop() else {
            phase = .idle
            return
        }
        await transcribeAndTranslate(fileURL: url)
    }

    /// Feeds a bundled clip through the exact same path as the microphone.
    func playSample() async {
        guard !phase.isBusy else { return }
        guard let clip = source.sampleClip,
              let url = Bundle.main.url(forResource: clip, withExtension: "m4a") else {
            phase = .error("No sample phrase for \(source.name).")
            return
        }
        guard await AppleSpeechTranscriber.requestAuthorization() else {
            phase = .error("Speech recognition is off. Turn it on in Settings.")
            return
        }
        await transcribeAndTranslate(fileURL: url)
    }

    private func transcribeAndTranslate(fileURL: URL) async {
        // Microphone recordings are transient. Bundled developer samples cannot be
        // removed, but recorded files are deleted as soon as transcription finishes.
        defer { try? FileManager.default.removeItem(at: fileURL) }
        phase = .transcribing
        let text: String
        do {
            text = try await transcriber.transcribe(fileURL: fileURL, locale: source.locale)
        } catch {
            phase = .error(error.localizedDescription)
            return
        }
        lastHeard = text
        await translateAndAppend(text, viaSpeech: true)
    }

    // MARK: - Pipeline

    private func translateAndAppend(_ text: String, viaSpeech: Bool) async {
        phase = .translating

        // iOS 18–25 supplies TranslationSession only through SwiftUI's
        // `.translationTask`; iOS 26 can additionally use the direct,
        // installed-pack API and then fall back to Apple Intelligence.
        guard #available(iOS 26.0, *) else {
            let request = PendingTranslation(text: text, source: source, target: target, viaSpeech: viaSpeech)
            startTranslationTask(for: .translate(request), source: source, target: target)
            return
        }

        do {
            let result = try await translator.translate(text, from: source, to: target)
            await append(result, original: text, source: source, target: target, viaSpeech: viaSpeech)
        } catch {
            await refreshStatus()
            phase = .error("Translation failed. \(error.localizedDescription)")
        }
    }

    private func translate(_ request: PendingTranslation, with session: TranslationSession) async {
        do {
            let response = try await session.translate(request.text)
            let result = TranslationResult(text: response.targetText, engine: .appleTranslation)
            await append(result, original: request.text, source: request.source, target: request.target, viaSpeech: request.viaSpeech)
        } catch {
            await refreshStatus()
            phase = .error("Translation failed. \(error.localizedDescription)")
        }
    }

    private func append(
        _ result: TranslationResult,
        original: String,
        source: AppLanguage,
        target: AppLanguage,
        viaSpeech: Bool
    ) async {
        let turn = Turn(source: source, target: target, original: original, translation: result.text, viaSpeech: viaSpeech, engine: result.engine)
        turns.append(turn)
        beginRetentionWindowIfNeeded()
        if autoSpeak {
            await speak(turn)
        } else {
            phase = .idle
        }
    }

    private func startTranslationTask(for action: TranslationTaskAction, source: AppLanguage, target: AppLanguage) {
        translationTaskAction = action
        // A fresh configuration reliably retriggers `.translationTask` for a
        // repeated request using the same language pair.
        translationConfiguration?.invalidate()
        translationConfiguration = .init(source: source.translationLanguage, target: target.translationLanguage)
    }

    func speak(_ turn: Turn) async {
        phase = .speaking
        await speaker.speak(turn.translation, locale: turn.target.locale)
        if phase == .speaking { phase = .idle }
    }

    func clearConversation() {
        speaker.stop()
        expiryTask?.cancel()
        expiryTask = nil
        turns.removeAll()
        handoffExpiresAt = nil
        lastHeard = nil
        phase = .idle
    }

    private func beginRetentionWindowIfNeeded() {
        guard handoffExpiresAt == nil else { return }
        handoffExpiresAt = Date().addingTimeInterval(retentionInterval)
        expiryTask?.cancel()
        expiryTask = Task { [weak self] in
            guard let self else { return }
            let nanoseconds = UInt64(max(0, retentionInterval) * 1_000_000_000)
            try? await Task.sleep(nanoseconds: nanoseconds)
            guard !Task.isCancelled else { return }
            self.clearConversation()
        }
    }

    nonisolated private static func retentionIntervalFromLaunchArguments() -> TimeInterval {
        #if DEBUG
        let arguments = ProcessInfo.processInfo.arguments
        if let index = arguments.firstIndex(of: "-retentionSeconds"),
           arguments.indices.contains(index + 1),
           let seconds = TimeInterval(arguments[index + 1]), seconds > 0 {
            return seconds
        }
        #endif
        return 30 * 60
    }
}
