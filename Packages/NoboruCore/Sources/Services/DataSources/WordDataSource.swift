import Foundation

public protocol WordDataSource {
    func loadWords() async throws -> WordList
}
