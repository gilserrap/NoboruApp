import Foundation

public protocol WordServiceable {
    func getWords(for category: WordCategory) -> [Word]
    func generateOptions(correctWord: Word, category: WordCategory) -> [String]
}

public final class WordService: WordServiceable {
    private struct JSON {
        static let wordList = "nonboru_full_wordlist"
    }

    public init() {}

    public static func loadLocalWords() -> [Word] {
        guard let url = Bundle.module.url(forResource: JSON.wordList, withExtension: "json"),
              let data = try? Data(contentsOf: url),
              let words = try? JSONDecoder().decode([Word].self, from: data) else {
            return []
        }
        return words
    }

    public func getWords(for category: WordCategory) -> [Word] {
        WordService.loadLocalWords().filter { $0.category == category }
    }

    public func generateOptions(correctWord: Word, category: WordCategory) -> [String] {
        let wrongAnswers = WordService.loadLocalWords()
            .filter { $0.category == category && $0.meaning != correctWord.meaning }
            .shuffled()
            .prefix(3)
            .map { $0.meaning }

        return (wrongAnswers + [correctWord.meaning]).shuffled()
    }
}

