import Foundation

public final class QuizService {
    private let wordService: WordServiceable

    public init(wordService: WordServiceable = WordService()) {
        self.wordService = wordService
    }

    public func generateQuiz(with settings: QuizSettings) -> Quiz {
        let words = wordService.getWords(for: settings.category).shuffled().prefix(10)

        let questions = words.map { word in
            let options = settings.mode == .multipleChoice
                ? generateOptions(correctWord: word, category: settings.category)
                : nil
            return QuizQuestion(
                kanaText: Self.selectKana(for: word, basedOn: settings.script),
                sourceScript: word.correctScript.toScriptOption(),
                correctAnswer: word.meaning,
                options: options
            )
        }

        return Quiz(settings: settings, questions: Array(questions))
    }

    private static func selectKana(for word: Word, basedOn script: ScriptOption) -> String {
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

    private func generateOptions(correctWord: Word, category: WordCategory) -> [String] {
        let wrongAnswers = wordService.getWords(for: category)
            .filter { $0.meaning != correctWord.meaning }
            .shuffled()
            .prefix(3)
            .map { $0.meaning }

        return (wrongAnswers + [correctWord.meaning]).shuffled()
    }
}
