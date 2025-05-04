import Foundation
import CoreData


extension CDWord {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CDWord> {
        return NSFetchRequest<CDWord>(entityName: "CDWord")
    }

    @NSManaged public var id: UUID?
    @NSManaged public var romaji: String?
    @NSManaged public var hiragana: String?
    @NSManaged public var katakana: String?
    @NSManaged public var meaning: String?
    @NSManaged public var correctScript: String?
    @NSManaged public var category: String?
    @NSManaged public var list: CDWordList?

}

extension CDWord : Identifiable {

}
