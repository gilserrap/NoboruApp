import Foundation

public struct QuizSummary {
    public var correct: Int
    public var incorrect: Int

    public init(correct: Int, incorrect: Int) {
        self.correct = correct
        self.incorrect = incorrect
    }

    public var total: Int {
        correct + incorrect
    }
}
