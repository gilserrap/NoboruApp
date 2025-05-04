import Foundation

public protocol WordServiceable {
    func getAllWords() async -> [Word]
    func getWords(for category: WordCategory) async -> [Word]
    func generateOptions(correctWord: Word, category: WordCategory) async -> [String]
}

public final class WordService: WordServiceable {

    private var wordCache: WordList? = nil

    public init() {}

    public func getAllWords() async -> [Word] {
        do {
            return try await loadRemoteWords()
        } catch {
            return loadLocalWords()
        }
    }

    public func getWords(for category: WordCategory) async -> [Word] {
        await getAllWords().filter { $0.category == category }
    }

    public func generateOptions(correctWord: Word, category: WordCategory) async -> [String] {
        let wrongAnswers = await getAllWords()
            .filter { $0.category == category && $0.meaning != correctWord.meaning }
            .shuffled()
            .prefix(3)
            .map { $0.meaning }

        return (wrongAnswers + [correctWord.meaning]).shuffled()
    }

    // MARK: - Word fetching
    private func loadLocalWords(from bundle: Bundle = .main) -> [Word] {
        guard let data = try? Data(contentsOf: URLValue.localFile),
              let wordList = try? JSONDecoder().decode(WordList.self, from: data) else {
            return []
        }
        wordCache = wordList
        return wordList.words
    }

    private func loadRemoteWords() async throws -> [Word] {
        let (data, _) = try await URLSession.shared.data(from: URLValue.gist)
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        let wordList = try decoder.decode(WordList.self, from: data)
        wordCache = wordList
        return wordList.words
    }

    // MARK: - URL values
    private struct URLValue {
        static let localFile = Bundle.module.url(
            forResource: "nonboru_full_wordlist",
            withExtension: "json"
        )!
        static let gist = URL(
            string: "https://gist.githubusercontent.com/gilserrap/a47b748a8833e8c7ab6491b20fb78814/raw/6c521f6418cbe82364247e18a9e7729a60d7bd70/noboru_full_wordlist.json"
        )!
    }
}

