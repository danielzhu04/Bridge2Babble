import Foundation
import FoundationModels
import Translation

/// The on-device engine that produced a translation.
enum TranslationEngine: String, Equatable {
    case appleTranslation = "Apple Translation"
    case appleIntelligence = "Apple Intelligence"
}

struct TranslationResult {
    let text: String
    let engine: TranslationEngine
}

protocol Translator {
    func translate(_ text: String, from source: AppLanguage, to target: AppLanguage) async throws -> TranslationResult
    func status(from source: AppLanguage, to target: AppLanguage) async -> LanguageStatus
}

enum LanguageStatus: Equatable {
    case ready(TranslationEngine)
    /// A language pack would improve things, but `fallback` can translate meanwhile.
    case needsDownload(fallback: TranslationEngine?)
    case unsupported
    case checking

    var label: String {
        switch self {
        case .ready(let engine): "Ready offline · \(engine.rawValue)"
        case .needsDownload(.some(let engine)): "Ready · \(engine.rawValue) (download for best quality)"
        case .needsDownload(.none): "Needs download"
        case .unsupported: "Not supported on this device"
        case .checking: "Checking…"
        }
    }

    var canTranslate: Bool {
        switch self {
        case .ready, .needsDownload(.some): true
        default: false
        }
    }

    var canDownload: Bool {
        if case .needsDownload = self { return true }
        return false
    }
}

enum TranslatorError: LocalizedError {
    case unavailable(String)
    case emptyResult

    var errorDescription: String? {
        switch self {
        case .unavailable(let reason): reason
        case .emptyResult: "The translation came back empty."
        }
    }
}

/// Apple's Translation framework. Uses installed language packs only;
/// downloads go through `.translationTask` in the UI. Not available in the Simulator.
struct AppleTranslationEngine {
    /// iOS 26 introduced a direct, installed-language-pack initializer. Earlier
    /// iOS versions deliver a `TranslationSession` through SwiftUI's
    /// `.translationTask`, so the view model uses that route instead.
    @available(iOS 26.0, *)
    func translate(_ text: String, from source: AppLanguage, to target: AppLanguage) async throws -> String {
        let session = TranslationSession(installedSource: source.translationLanguage, target: target.translationLanguage)
        return try await session.translate(text).targetText
    }

    func availability(from source: AppLanguage, to target: AppLanguage) async -> LanguageAvailability.Status {
        await LanguageAvailability().status(from: source.translationLanguage, to: target.translationLanguage)
    }
}

/// Apple Intelligence's on-device foundation model, prompted to act as a translator.
///
/// This engine is deliberately available only on iOS 26 and later. Keeping the
/// type behind an availability boundary lets older devices use Apple
/// Translation without carrying an unavailable Foundation Models dependency at
/// runtime.
@available(iOS 26.0, *)
struct AppleIntelligenceEngine {
    var isAvailable: Bool {
        if case .available = SystemLanguageModel.default.availability { return true }
        return false
    }

    var unavailableReason: String {
        switch SystemLanguageModel.default.availability {
        case .available: ""
        case .unavailable(.deviceNotEligible): "This device doesn't support Apple Intelligence."
        case .unavailable(.appleIntelligenceNotEnabled): "Turn on Apple Intelligence in Settings."
        case .unavailable(.modelNotReady): "Apple Intelligence is still downloading."
        case .unavailable: "Apple Intelligence isn't available."
        }
    }

    func translate(_ text: String, from source: AppLanguage, to target: AppLanguage) async throws -> String {
        let session = LanguageModelSession(instructions: """
            You are a live interpreter. Translate the user's message from \(source.name) into natural, \
            conversational \(target.name). Reply with only the \(target.name) translation: no quotes, \
            no notes, no romanization, no explanation.
            """)
        let response = try await session.respond(to: text)
        let output = response.content.trimmingCharacters(in: .whitespacesAndNewlines)
            .trimmingCharacters(in: CharacterSet(charactersIn: "\"“”"))
        guard !output.isEmpty else { throw TranslatorError.emptyResult }
        return output
    }
}

/// Prefers Apple Translation when its language pack is installed and falls
/// back to Apple Intelligence. Everything stays on the device either way.
struct OnDeviceTranslator: Translator {
    private let translation = AppleTranslationEngine()

    func translate(_ text: String, from source: AppLanguage, to target: AppLanguage) async throws -> TranslationResult {
        if await translation.availability(from: source, to: target) == .installed {
            if #available(iOS 26.0, *) {
                return TranslationResult(text: try await translation.translate(text, from: source, to: target), engine: .appleTranslation)
            }
            throw TranslatorError.unavailable("Use the Apple Translation session supplied by the app on iOS 18 through iOS 25.")
        }

        guard #available(iOS 26.0, *) else {
            throw TranslatorError.unavailable("\(source.name) → \(target.name) needs a download. Apple Intelligence requires iOS 26 or later.")
        }

        let intelligence = AppleIntelligenceEngine()
        guard intelligence.isAvailable else {
            throw TranslatorError.unavailable("\(source.name) → \(target.name) needs a download, and \(intelligence.unavailableReason)")
        }
        return TranslationResult(text: try await intelligence.translate(text, from: source, to: target), engine: .appleIntelligence)
    }

    func status(from source: AppLanguage, to target: AppLanguage) async -> LanguageStatus {
        let fallback: TranslationEngine?
        if #available(iOS 26.0, *) {
            fallback = AppleIntelligenceEngine().isAvailable ? .appleIntelligence : nil
        } else {
            fallback = nil
        }
        switch await translation.availability(from: source, to: target) {
        case .installed: return .ready(.appleTranslation)
        case .supported: return .needsDownload(fallback: fallback)
        default: return fallback.map { .ready($0) } ?? .unsupported
        }
    }
}
