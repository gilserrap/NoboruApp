import Foundation

public protocol InMemoryWordDataSourceable: WordDataSourceable {}

public final class InMemoryWordDataSource: InMemoryWordDataSourceable {
    public var wordList: WordList?

    public init() {}

    public func loadWords() async throws -> WordList {
        guard let wordList = wordList else {
            throw WordDataSourceError.noCacheAvailable
        }
        return wordList
    }

    public func save(words: WordList) async throws {
        wordList = words
    }

    enum WordDataSourceError: Error {
        case noCacheAvailable
    }
}
