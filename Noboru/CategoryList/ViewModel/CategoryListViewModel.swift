import Additions
import Foundation
import NoboruCore

@MainActor
public class CategoryListViewModel: ObservableObject {

    @Inject private var wordService: WordServiceable

    @Published public var words: [Word] = []

    public init() {}

    public func loadWords(from bundle: Bundle = .main) async {
        self.words = await wordService.getAllWords()
    }

    public func words(for category: WordCategory) -> [Word] {
        words.filter { $0.category == category }
    }
}
