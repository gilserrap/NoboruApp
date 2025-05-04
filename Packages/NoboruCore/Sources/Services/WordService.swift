import Foundation
import Additions

public protocol WordServiceable {
    func getAllWords() async -> [Word]
    func getWords(for category: WordCategory) async -> [Word]
    func generateOptions(correctWord: Word, category: WordCategory) async -> [String]
}

public final class WordService: WordServiceable {
    @Inject private var remote: RemoteWordDataSourceable
    @Inject private var local: InMemoryWordDataSourceable
    @Inject private var coreData: CoreDataWordDataSourceable

    private var wordCache: WordList?

    public init() {}

    public func getAllWords() async -> [Word] {
        if let cached = wordCache {
            return cached.words
        }
        do {
            let remoteList = try await remote.loadWords()
            let coreDataList = try await coreData.loadWords()
            if coreDataList.updatedAt >= remoteList.updatedAt {
                wordCache = coreDataList
                return coreDataList.words
            } else {
                wordCache = remoteList
                try await coreData.save(words: remoteList)
                return remoteList.words
            }
        } catch {
            do {
                let fallback = try await local.loadWords()
                wordCache = fallback
                return fallback.words
            } catch {
                return []
            }
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
}
