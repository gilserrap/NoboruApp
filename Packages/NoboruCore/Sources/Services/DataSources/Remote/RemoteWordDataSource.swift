import Foundation

public protocol RemoteWordDataSourceable: WordDataSourceable {}

public final class RemoteWordDataSource: RemoteWordDataSourceable {

    private struct Constant {
        static let defaultUrl = URL(string: "https://gist.githubusercontent.com/gilserrap/a47b748a8833e8c7ab6491b20fb78814/raw/6c521f6418cbe82364247e18a9e7729a60d7bd70/noboru_full_wordlist.json")!
    }

    public init() {}

    public func loadWords() async throws -> WordList {
        let (data, _) = try await URLSession.shared.data(from: Constant.defaultUrl)
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        return try decoder.decode(WordList.self, from: data)
    }

    public func save(words: WordList) async throws {
        assertionFailure("Remote data source does not support saving words.")
    }
}
