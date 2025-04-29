import Foundation

public struct QuizQuestion: Identifiable, Codable, Equatable {
    public let id: UUID
    public let kanaText: String
    public let sourceScript: QuizScriptOption
    public let correctAnswer: String
    public let options: [String]?

    public init(
        id: UUID = UUID(),
        kanaText: String,
        sourceScript: QuizScriptOption,
        correctAnswer: String,
        options: [String]? = nil
    ) {
        self.id = id
        self.kanaText = kanaText
        self.sourceScript = sourceScript
        self.correctAnswer = correctAnswer
        self.options = options
    }
}
