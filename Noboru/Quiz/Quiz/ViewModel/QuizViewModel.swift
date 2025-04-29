import Foundation
import SwiftUI
import NoboruCore

@MainActor
public final class QuizViewModel: ObservableObject {
    public let settings: QuizSettings
    private let wordService: WordService
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

    public init(settings: QuizSettings, wordService: WordService = WordService()) {
        self.settings = settings
        self.wordService = wordService
        loadQuestions()
    }

    private func loadQuestions() {
        let allWords = wordService.getWords(for: settings.category)
        let shuffled = allWords.shuffled()
        let selectedWords = Array(shuffled.prefix(10))

        self.questions = selectedWords.map { word in
            QuizQuestion(
                kanaText: Self.selectKana(for: word, basedOn: settings.script),
                sourceScript: word.correctScript.toScriptOption(),
                correctAnswer: word.meaning,
                options: settings.mode == .multipleChoice ? wordService.generateOptions(correctWord: word, category: settings.category) : nil
            )
        }
    }

    private static func selectKana(for word: Word, basedOn script: QuizScriptOption) -> String {
        switch script {
        case .hiragana:
            return word.hiragana
        case .katakana:
            return word.katakana
        case .correct:
            switch word.correctScript {
            case .hiragana:
                return word.hiragana
            case .katakana:
                return word.katakana
            }
        }
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

    public func buttonBackground(for index: Int) -> Color {
        guard showAnswerResult else {
            return Color(UIColor.secondarySystemBackground)
        }
        if index == currentQuestion.options?.firstIndex(of: currentQuestion.correctAnswer) {
            return Color.green.opacity(0.6)
        } else if index == selectedAnswerIndex {
            return Color.red.opacity(0.6)
        } else {
            return Color(UIColor.secondarySystemBackground)
        }
    }
}
