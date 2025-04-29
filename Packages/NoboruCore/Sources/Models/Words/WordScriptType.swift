import Foundation

public enum WordScriptType: String, Codable {
    case hiragana
    case katakana
}

extension WordScriptType {
    public func toScriptOption() -> QuizScriptOption {
        switch self {
        case .hiragana:
            return .hiragana
        case .katakana:
            return .katakana
        }
    }
}
