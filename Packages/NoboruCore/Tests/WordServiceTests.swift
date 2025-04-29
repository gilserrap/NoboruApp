import XCTest
@testable import NoboruCore

final class WordServiceTests: XCTestCase {
    func testLoadLocalWords() {
        let words = WordService.loadLocalWords()
        XCTAssertFalse(words.isEmpty, "Expected non-empty word list.")
    }
}
