import Foundation

/// One exchange in the conversation: what was said and what it means in the other language.
struct Turn: Identifiable, Equatable {
    let id = UUID()
    let source: AppLanguage
    let target: AppLanguage
    let original: String
    let translation: String
    let viaSpeech: Bool
    let engine: TranslationEngine
}
