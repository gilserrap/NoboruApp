import Foundation
import NoboruCore

@MainActor
public class CategoryListViewModel: ObservableObject {
    @Published public var words: [Word] = []

    public init() {}

    public func loadWords(from bundle: Bundle = .main) {
        self.words = WordService.loadLocalWords()
    }

    public func words(for category: WordCategory) -> [Word] {
        words.filter { $0.category == category }
    }
}
