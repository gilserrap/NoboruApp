import Foundation

public enum QuizMode: String, CaseIterable, Codable {
    case multipleChoice
    case freeInput

    public var displayName: String {
        switch self {
        case .multipleChoice: return "Multiple Choice"
        case .freeInput: return "Type Answer"
        }
    }
}
