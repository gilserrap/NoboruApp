import Foundation

public struct WordList: Codable {
    public let updatedAt: Date
    public let words: [Word]

    public init(updatedAt: Date, words: [Word]) {
        self.updatedAt = updatedAt
        self.words = words
    }
}

extension WordList {
    private struct Constant {
        static let bundle = Bundle.module
        static let filename = "nonboru_full_wordlist"
    }

    static func loadFromLocalFile() -> WordList {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        guard
            let url = Constant.bundle.url(forResource: Constant.filename, withExtension: "json"),
            let data = try? Data(contentsOf: url),
            let list = try? decoder.decode(WordList.self, from: data)
        else {
            return WordList(updatedAt: Date(), words: [])
        }
        return list
    }
}
