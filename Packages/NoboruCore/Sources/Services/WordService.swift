import Foundation
import Additions

public protocol WordServiceable {
    func getAllWords() async -> [Word]
    func getWords(for category: WordCategory) async -> [Word]
    func generateOptions(correctWord: Word, category: WordCategory) async -> [String]
}

public final class WordService: WordServiceable {
    @Inject private var remote: RemoteWordDataSourceable
    @Inject private var memory: InMemoryWordDataSourceable
    @Inject private var coreData: CoreDataWordDataSourceable

    public init() {}

    public func getAllWords() async -> [Word] {
        if let cached = try? await memory.loadWords() {
            return cached.words
        }
        do {
            return try await loadRemoteWords()
        } catch {
            do {
                return try await loadCoreDataWords()
            } catch {
                return await loadHardcodedWords()
            }
        }
    }

    private func loadRemoteWords() async throws -> [Word] {
        let remoteList = try await remote.loadWords()
        try? await self.memory.save(words: remoteList)
        try? await self.coreData.save(words: remoteList)
        return remoteList.words
    }

    private func loadCoreDataWords() async throws -> [Word] {
        let coreData = try await coreData.loadWords()
        try await self.memory.save(words: coreData)
        return coreData.words
    }

    private func loadHardcodedWords() async -> [Word] {
        let localCopy = WordList.loadFromLocalFile()
        try? await self.memory.save(words: localCopy)
        try? await self.coreData.save(words: localCopy)
        return localCopy.words
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
