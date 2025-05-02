import Foundation
import Additions

public protocol QuizServiceable {
    func generateQuiz(with settings: QuizSettings) async -> [QuizQuestion]
}

public final class QuizService: QuizServiceable {

    @Inject private var wordService: WordServiceable

    public init() {}

    public func generateQuiz(with settings: QuizSettings) async -> [QuizQuestion] {
        let words = await wordService.getWords(for: settings.category).shuffled().prefix(10)

        var questions: [QuizQuestion] = []
        for word in words {
            let options = await settings.mode == .multipleChoice
                ? generateOptions(correctWord: word, category: settings.category)
                : nil
            questions.append(QuizQuestion(
                kanaText: Self.selectKana(for: word, basedOn: settings.script),
                sourceScript: word.correctScript.toScriptOption(),
                correctAnswer: word.meaning,
                options: options
            ))
        }

        return questions
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

    private func generateOptions(correctWord: Word, category: WordCategory) async -> [String] {
        let wrongAnswers = await wordService.getWords(for: category)
            .filter { $0.meaning != correctWord.meaning }
            .shuffled()
            .prefix(3)
            .map { $0.meaning }

        return (wrongAnswers + [correctWord.meaning]).shuffled()
    }
}
