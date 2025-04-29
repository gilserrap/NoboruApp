import Foundation
import SwiftUI
import NoboruCore

@MainActor
public final class QuizViewModel: ObservableObject {
    public let settings: QuizSettings
    private let quizService: QuizService

    public struct State {
        public var questions: [QuizQuestion] = []
        public var currentQuestionIndex: Int = 0
        public var selectedAnswerIndex: Int? = nil
        public var userInput: String = ""
        public var showAnswerResult: Bool = false
        public var isAnswerCorrect: Bool = false
        public var finished: Bool = false
        public var quizSummary = QuizSummary(correct: 0, incorrect: 0)

        public var currentQuestion: QuizQuestion {
            questions[currentQuestionIndex]
        }
        public var displayedQuestion: String {
            currentQuestion.kanaText
        }
    }

    @Published public var state: State = .init()

    public init(settings: QuizSettings, quizService: QuizService = QuizService()) {
        self.settings = settings
        self.quizService = quizService
        loadQuestions()
    }

    internal init(model: State, settings: QuizSettings, quizService: QuizService = QuizService()) {
        self.settings = settings
        self.quizService = quizService
        self.state = model
    }

    private func loadQuestions() {
        state.questions = QuizService().generateQuiz(with: settings)
    }

    public func handleMultipleChoiceAnswer(_ index: Int) {
        state.selectedAnswerIndex = index
        state.showAnswerResult = true
        state.isAnswerCorrect = (index == state.currentQuestion.options?.firstIndex(of: state.currentQuestion.correctAnswer) ?? -1)
        if state.isAnswerCorrect {
            state.quizSummary.correct += 1
        } else {
            state.quizSummary.incorrect += 1
        }
    }

    public func handleFreeInputAnswer() {
        state.isAnswerCorrect =
            state.userInput.trimmingCharacters(in: .whitespacesAndNewlines).lowercased() ==
            state.currentQuestion.correctAnswer.lowercased()
    }

    public func goToNextQuestion() {
        if state.currentQuestionIndex < state.questions.count - 1 {
            state.currentQuestionIndex += 1
            state.selectedAnswerIndex = nil
            state.userInput = ""
            state.showAnswerResult = false
            state.isAnswerCorrect = false
        } else {
            state.finished = true
        }
    }
}
