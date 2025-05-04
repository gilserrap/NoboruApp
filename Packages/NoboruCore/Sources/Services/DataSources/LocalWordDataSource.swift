import Foundation

public protocol LocalWordDataSourceable: WordDataSource {}

public final class LocalWordDataSource: LocalWordDataSourceable {

    private struct Constant {
        static let bundle = Bundle.module
        static let filename = "nonboru_full_wordlist"
    }

    public init() {}

    public func loadWords() async throws -> WordList {
        guard let url = Constant.bundle.url(forResource: Constant.filename, withExtension: "json") else {
            throw WordDataSourceError.fileNotFound
        }
        let data = try Data(contentsOf: url)
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        return try decoder.decode(WordList.self, from: data)
    }

    enum WordDataSourceError: Error {
        case fileNotFound
    }
}
