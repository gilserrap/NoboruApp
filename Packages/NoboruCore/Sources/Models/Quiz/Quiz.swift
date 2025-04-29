import Foundation

public struct Quiz {
    public let settings: QuizSettings
    public let questions: [QuizQuestion]

    public init(
        settings: QuizSettings,
        questions: [QuizQuestion]
    ) {
        self.settings = settings
        self.questions = questions
    }
}
