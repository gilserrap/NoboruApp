import Foundation

public protocol InMemoryWordDataSourceable: WordDataSourceable {}

public final class InMemoryWordDataSource: InMemoryWordDataSourceable {

    private struct Constant {
        static let bundle = Bundle.module
        static let filename = "nonboru_full_wordlist"
    }

    public var wordList: WordList?

    public init() {
        do {
            guard let url = Constant.bundle.url(forResource: Constant.filename, withExtension: "json") else {
                throw WordDataSourceError.fileNotFound
            }
            let data = try Data(contentsOf: url)
            let decoder = JSONDecoder()
            decoder.dateDecodingStrategy = .iso8601
            wordList = try decoder.decode(WordList.self, from: data)
        } catch {
            print("Error loading words: \(error)")
        }
    }

    public func loadWords() async throws -> WordList {
        if let wordList =  wordList {
            return wordList
        } else {
            throw WordDataSourceError.failedToLoadCache
        }
    }

    public func save(words: WordList) async throws {
        wordList = words
    }

    enum WordDataSourceError: Error {
        case failedToLoadCache
        case fileNotFound
    }
}
