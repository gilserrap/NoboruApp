import Foundation
import Additions
import CoreData

public protocol CoreDataWordDataSourceable: WordDataSourceable {
    func loadWords() async throws -> WordList
    func save(words: WordList) async throws
}

public final class CoreDataWordDataSource: CoreDataWordDataSourceable {

    @Inject private var context: NSManagedObjectContext

    public init() {}

    public func loadWords() async throws -> WordList {
        let request: NSFetchRequest<CDWordList> = CDWordList.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(key: "updatedAt", ascending: false)]
        request.fetchLimit = 1

        guard let cdList = try context.fetch(request).first else {
            throw WordDataSourceError.noData
        }

        let words = (cdList.words?.allObjects as? [CDWord] ?? []).map { $0.toDomain() }

        return WordList(updatedAt: cdList.updatedAt ?? Date(), words: words)
    }

    public func save(words: WordList) async throws {
        // Delete old lists
        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = CDWordList.fetchRequest()
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        try context.execute(deleteRequest)

        // Create new CDWordList
        let cdList = CDWordList(context: context)
        cdList.updatedAt = words.updatedAt

        for word in words.words {
            let cdWord = CDWord(context: context)
            cdWord.id = word.id
            cdWord.romaji = word.romaji
            cdWord.hiragana = word.hiragana
            cdWord.katakana = word.katakana
            cdWord.meaning = word.meaning
            cdWord.correctScript = word.correctScript.rawValue
            cdWord.category = word.category.rawValue
            cdWord.list = cdList
        }

        try context.save()
    }
}

public enum WordDataSourceError: Error {
    case noData
}
