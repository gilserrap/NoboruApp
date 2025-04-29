import Foundation
import XCTest
@testable import NoboruCore

final class MockWordService: WordServiceable {
    private let mockWords: [Word]

    public init(mockWords: [Word]) {
        self.mockWords = mockWords
    }

    public func getWords(for category: WordCategory) -> [Word] {
        mockWords.filter { $0.category == category }
    }

    public func generateOptions(correctWord: Word, category: WordCategory) -> [String] {
        []
    }
}

final class QuizServiceTests: XCTestCase {
    private var mockWords: [Word] = []
    private var quizService: QuizService!

    override func setUp() {
        super.setUp()

        mockWords = [
            Word(
                id: UUID(),
                romaji: "noboru",
                hiragana: "のぼる",
                katakana: "ノボル",
                meaning: "to climb",
                correctScript: .hiragana,
                category: .action
            ),
            Word(
                id: UUID(),
                romaji: "suberu",
                hiragana: "すべる",
                katakana: "スベル",
                meaning: "to slip",
                correctScript: .hiragana,
                category: .action
            ),
            Word(
                id: UUID(),
                romaji: "kurippu",
                hiragana: "くりっぷ",
                katakana: "クリップ",
                meaning: "crimp",
                correctScript: .katakana,
                category: .hold
            ),
            Word(
                id: UUID(),
                romaji: "jagu",
                hiragana: "じゃぐ",
                katakana: "ジャグ",
                meaning: "jug",
                correctScript: .katakana,
                category: .hold
            )
        ]

        let mockService = MockWordService(mockWords: mockWords)
        quizService = QuizService(wordService: mockService)
    }

    func testGeneratesCorrectNumberOfQuestions() {
        let settings = QuizSettings(
            script: .correct,
            category: .hold,
            mode: .multipleChoice,
            showRomaji: true
        )

        let questions = quizService.generateQuiz(with: settings)
        XCTAssertLessThanOrEqual(questions.count, 10)
    }

    func testAllQuestionsMatchCategory() {
        let settings = QuizSettings(
            script: .hiragana,
            category: .action,
            mode: .freeInput,
            showRomaji: false
        )

        let questions = quizService.generateQuiz(with: settings)
        let expectedMeanings = mockWords
            .filter { $0.category == .action }
            .map(\.meaning)

        for question in questions {
            XCTAssertTrue(expectedMeanings.contains(question.correctAnswer))
        }
    }

    func testKanaTextRespectsScriptSetting() {
        let settings = QuizSettings(
            script: .katakana,
            category: .hold,
            mode: .freeInput,
            showRomaji: false
        )

        let questions = quizService.generateQuiz(with: settings)
        let expectedKatakana = mockWords
            .filter { $0.category == .hold }
            .map(\.katakana)

        for question in questions {
            XCTAssertTrue(expectedKatakana.contains(question.kanaText),
                          "Unexpected kana: \(question.kanaText)")
        }
    }

    func testCorrectAnswerIncludedInOptions() {
        let settings = QuizSettings(
            script: .correct,
            category: .hold,
            mode: .multipleChoice,
            showRomaji: false
        )

        let questions = quizService.generateQuiz(with: settings)

        for question in questions {
            XCTAssertNotNil(question.options)
            XCTAssertTrue(question.options!.contains(question.correctAnswer))
        }
    }

    func testMultipleChoiceOptionsAreUnique() {
        let settings = QuizSettings(
            script: .correct,
            category: .hold,
            mode: .multipleChoice,
            showRomaji: false
        )

        let questions = quizService.generateQuiz(with: settings)

        for question in questions {
            let options = question.options ?? []
            let uniqueOptions = Set(options)
            XCTAssertEqual(options.count, uniqueOptions.count,
                           "Duplicate options in: \(options)")
        }
    }
}
