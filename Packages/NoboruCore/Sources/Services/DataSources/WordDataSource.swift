import Foundation

public protocol WordDataSourceable {
    func loadWords() async throws -> WordList
    func save(words: WordList) async throws
}
