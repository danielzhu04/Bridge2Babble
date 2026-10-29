import Foundation

/// A language the app can listen to, translate between, and speak.
struct AppLanguage: Identifiable, Hashable {
    /// Locale used for speech recognition and text-to-speech, e.g. "en-US".
    let id: String
    /// Identifier used by the Translation framework, e.g. "zh-Hans".
    let translationID: String
    let name: String
    let flag: String
    /// Bundled sample clip (without extension) that speaks a phrase in this language.
    let sampleClip: String?

    var locale: Locale { Locale(identifier: id) }
    var translationLanguage: Locale.Language { Locale.Language(identifier: translationID) }

    static let english = AppLanguage(id: "en-US", translationID: "en", name: "English", flag: "🇺🇸", sampleClip: "sample_en")
    static let spanish = AppLanguage(id: "es-ES", translationID: "es", name: "Spanish", flag: "🇪🇸", sampleClip: "sample_es")
    static let french = AppLanguage(id: "fr-FR", translationID: "fr", name: "French", flag: "🇫🇷", sampleClip: "sample_fr")
    static let german = AppLanguage(id: "de-DE", translationID: "de", name: "German", flag: "🇩🇪", sampleClip: "sample_de")
    static let japanese = AppLanguage(id: "ja-JP", translationID: "ja", name: "Japanese", flag: "🇯🇵", sampleClip: "sample_ja")
    static let korean = AppLanguage(id: "ko-KR", translationID: "ko", name: "Korean", flag: "🇰🇷", sampleClip: nil)
    static let chinese = AppLanguage(id: "zh-CN", translationID: "zh-Hans", name: "Chinese", flag: "🇨🇳", sampleClip: nil)

    static let all: [AppLanguage] = [english, spanish, french, german, japanese, korean, chinese]
}
