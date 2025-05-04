import Foundation

public struct WordList: Codable {
    public let updatedAt: Date
    public let words: [Word]

    public init(updatedAt: Date, words: [Word]) {
        self.updatedAt = updatedAt
        self.words = words
    }
}
