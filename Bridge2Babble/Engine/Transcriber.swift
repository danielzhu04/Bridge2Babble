import AVFoundation
import Speech

protocol Transcriber {
    func transcribe(fileURL: URL, locale: Locale) async throws -> String
}

enum TranscriberError: LocalizedError {
    case unsupportedLocale(String)
    case onDeviceModelUnavailable(String)
    case nothingHeard

    var errorDescription: String? {
        switch self {
        case .unsupportedLocale(let id): "Speech recognition isn't available for \(id) on this device."
        case .onDeviceModelUnavailable(let id): "On-device speech recognition for \(id) isn't downloaded on this iPhone."
        case .nothingHeard: "Didn't catch that. Try speaking again."
        }
    }
}

/// On-device speech-to-text using SpeechAnalyzer (iOS 26). Falls back to the
/// classic on-device SFSpeechRecognizer when SpeechTranscriber can't run here.
struct AppleSpeechTranscriber: Transcriber {
    func transcribe(fileURL: URL, locale: Locale) async throws -> String {
        if #available(iOS 26.0, *),
           SpeechTranscriber.isAvailable,
           let supported = await SpeechTranscriber.supportedLocale(equivalentTo: locale) {
            do {
                return try await transcribeWithAnalyzer(fileURL: fileURL, locale: supported)
            } catch {
                print("SpeechAnalyzer failed, falling back to SFSpeechRecognizer: \(error)")
            }
        }
        return try await transcribeWithRecognizer(fileURL: fileURL, locale: locale)
    }

    @available(iOS 26.0, *)
    private func transcribeWithAnalyzer(fileURL: URL, locale: Locale) async throws -> String {
        let transcriber = SpeechTranscriber(locale: locale, preset: .transcription)
        if let request = try await AssetInventory.assetInstallationRequest(supporting: [transcriber]) {
            try await request.downloadAndInstall()
        }

        let collector = Task {
            var text = ""
            for try await result in transcriber.results where result.isFinal {
                text += String(result.text.characters)
            }
            return text
        }

        let file = try AVAudioFile(forReading: fileURL)
        let analyzer = SpeechAnalyzer(modules: [transcriber])
        if let end = try await analyzer.analyzeSequence(from: file) {
            try await analyzer.finalizeAndFinish(through: end)
        } else {
            await analyzer.cancelAndFinishNow()
        }

        let text = try await collector.value.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !text.isEmpty else { throw TranscriberError.nothingHeard }
        return text
    }

    private func transcribeWithRecognizer(fileURL: URL, locale: Locale) async throws -> String {
        guard let recognizer = SFSpeechRecognizer(locale: locale), recognizer.isAvailable else {
            throw TranscriberError.unsupportedLocale(locale.identifier)
        }
        let request = SFSpeechURLRecognitionRequest(url: fileURL)
        #if targetEnvironment(simulator)
        // The Simulator ships no on-device speech models, so dev/test builds use Apple's
        // server recognizer there. On a real iPhone recognition stays on-device.
        request.requiresOnDeviceRecognition = false
        #else
        // Clinic speech must never silently leave the phone. If the selected
        // language lacks an installed on-device model, surface that setup
        // issue instead of allowing SFSpeechRecognizer's network fallback.
        guard recognizer.supportsOnDeviceRecognition else {
            throw TranscriberError.onDeviceModelUnavailable(locale.identifier)
        }
        request.requiresOnDeviceRecognition = true
        #endif
        request.shouldReportPartialResults = false

        let text: String = try await withCheckedThrowingContinuation { continuation in
            var finished = false
            recognizer.recognitionTask(with: request) { result, error in
                guard !finished else { return }
                if let error {
                    finished = true
                    continuation.resume(throwing: error)
                } else if let result, result.isFinal {
                    finished = true
                    continuation.resume(returning: result.bestTranscription.formattedString)
                }
            }
        }
        guard !text.isEmpty else { throw TranscriberError.nothingHeard }
        return text
    }

    static func requestAuthorization() async -> Bool {
        await withCheckedContinuation { continuation in
            SFSpeechRecognizer.requestAuthorization { continuation.resume(returning: $0 == .authorized) }
        }
    }
}
