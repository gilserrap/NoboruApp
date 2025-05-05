import XCTest
import Additions
@testable import NoboruCore

final class WordServiceTests: XCTestCase {

    // MARK: - Mocks
    private var memory: WordDataSourceableMock!
    private var remote: WordDataSourceableMock!
    private var coreData: WordDataSourceableMock!

    // MARK: - Setup
    override func setUp() async throws {
        try await super.setUp()

        CoreServiceLocator.shared.removeAll()

        memory = WordDataSourceableMock()
        remote = WordDataSourceableMock()
        coreData = WordDataSourceableMock()

        CoreServiceLocator.shared.add {
            Register(RemoteWordDataSourceable.self) { self.remote }
            Register(CoreDataWordDataSourceable.self) { self.coreData }
            Register(InMemoryWordDataSourceable.self) { self.memory }
        }
    }

    // MARK: - Tests
    func test_givenThereIsMemoryCache_shouldLoadFromMemoy() async throws {
        memory.wordList = .fixture("memory")
        remote.wordList = .fixture("remote")
        coreData.wordList = .fixture("coredata")

        let words = await WordService().getAllWords()
        XCTAssertEqual(words.first?.romaji, "memory")
    }

    func test_givenThereIsNoMemoryCache_shouldLoadFromRemoteAndUpdatesCoreDataAndMemory() async throws {
        memory.wordList = nil
        remote.wordList = .fixture("remote")
        coreData.wordList = .fixture("coredata")

        let words = await WordService().getAllWords()

        XCTAssertEqual(words.first?.romaji, "remote")
        XCTAssertEqual(memory.wordList?.words.first?.romaji, "remote")
        XCTAssertEqual(coreData.wordList?.words.first?.romaji, "remote")
    }

    func test_givenRemoteFails_shouldLoadFromCoreDataAndUpdateMemoryCache() async throws {
        memory.wordList = nil
        remote.shouldFail = true
        coreData.wordList = .fixture("coredata")

        let words = await WordService().getAllWords()

        XCTAssertEqual(words.first?.romaji, "coredata")
        XCTAssertEqual(memory.wordList?.words.first?.romaji, "coredata")
    }

    func test_givenAllOtherMethodsFail_shouldFallBackToLocalFile() async throws {
        memory.wordList = nil
        remote.shouldFail = true
        coreData.shouldFail = true

        let words = await WordService().getAllWords()

        XCTAssertFalse(words.isEmpty, "Should return fallback local words")
        XCTAssertEqual(memory.wordList?.words.count, words.count)
        XCTAssertNil(coreData.wordList)
    }
}


class WordDataSourceableMock: RemoteWordDataSourceable, InMemoryWordDataSourceable, CoreDataWordDataSourceable {

    enum MockError: Error {
        case mockError
    }

    var wordList: WordList? = nil
    var shouldFail: Bool = false

    func loadWords() async throws -> WordList {
        guard let wordList, !shouldFail else {
            throw MockError.mockError
        }
        return wordList
    }
    
    func save(words: WordList) async throws {
        if shouldFail {
            throw MockError.mockError
        }
        wordList = words
    }
}

extension WordList {
    static func fixture(_ source: String) -> WordList {
        WordList(
            updatedAt: .now,
            words: [
                Word(
                    id: UUID(),
                    romaji: source,
                    hiragana: "のぼる",
                    katakana: "ノボル",
                    meaning: "to climb",
                    correctScript: .hiragana,
                    category: .action
                )
            ]
        )
    }
}
