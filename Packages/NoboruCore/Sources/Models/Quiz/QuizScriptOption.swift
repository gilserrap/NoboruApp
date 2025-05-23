import Foundation

public enum QuizScriptOption: String, CaseIterable, Codable {
    case hiragana
    case katakana
    case correct

    public var displayName: String {
        switch self {
        case .hiragana: return "Hiragana"
        case .katakana: return "Katakana"
        case .correct: return "Correct"
        }
    }
}
