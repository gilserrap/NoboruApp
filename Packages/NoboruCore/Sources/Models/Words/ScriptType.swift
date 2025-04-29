import Foundation

public enum ScriptType: String, Codable {
    case hiragana
    case katakana
    case correct
}

extension ScriptType {
    public func toScriptOption() -> ScriptOption {
        switch self {
        case .hiragana:
            return .hiragana
        case .katakana:
            return .katakana
        case .correct:
            return .correct
        }
    }
}
