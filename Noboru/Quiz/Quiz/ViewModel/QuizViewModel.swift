import Foundation
import SwiftUI
import NoboruCore

@MainActor
public final class QuizViewModel: ObservableObject {
    public let settings: QuizSettings
    private let quizService: QuizService
    public private(set) var quizSummary = QuizSummary(correct: 0, incorrect: 0)

    @Published public private(set) var questions: [QuizQuestion] = []
    @Published public private(set) var currentQuestionIndex: Int = 0
    @Published public var selectedAnswerIndex: Int? = nil
    @Published public var userInput: String = ""
    @Published public var showAnswerResult: Bool = false
    @Published public var isAnswerCorrect: Bool = false
    @Published public var finished: Bool = false

    public var currentQuestion: QuizQuestion {
        questions[currentQuestionIndex]
    }

    public var displayedQuestion: String {
        currentQuestion.kanaText
    }

    public init(settings: QuizSettings, quizService: QuizService = QuizService()) {
        self.settings = settings
        self.quizService = quizService
        loadQuestions()
    }

    private func loadQuestions() {
        self.questions = QuizService().generateQuiz(with: settings)
    }

    public func handleMultipleChoiceAnswer(_ index: Int) {
        selectedAnswerIndex = index
        showAnswerResult = true
        isAnswerCorrect = (index == currentQuestion.options?.firstIndex(of: currentQuestion.correctAnswer) ?? -1)
        if isAnswerCorrect {
            quizSummary.correct += 1
        } else {
            quizSummary.incorrect += 1
        }
    }

    public func handleFreeInputAnswer() {
        showAnswerResult = true
        isAnswerCorrect = userInput.trimmingCharacters(in: .whitespacesAndNewlines).lowercased() ==
                          currentQuestion.correctAnswer.lowercased()
    }

    public func goToNextQuestion() {
        if currentQuestionIndex < questions.count - 1 {
            currentQuestionIndex += 1
            selectedAnswerIndex = nil
            userInput = ""
            showAnswerResult = false
            isAnswerCorrect = false
        } else {
            finished = true
        }
    }
}
