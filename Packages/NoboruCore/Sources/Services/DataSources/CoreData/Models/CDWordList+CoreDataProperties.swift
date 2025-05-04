import Foundation
import CoreData


extension CDWordList {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CDWordList> {
        return NSFetchRequest<CDWordList>(entityName: "CDWordList")
    }

    @NSManaged public var updatedAt: Date?
    @NSManaged public var words: NSSet?

    @objc(addWordsObject:)
    @NSManaged public func addToWords(_ value: CDWord)

    @objc(removeWordsObject:)
    @NSManaged public func removeFromWords(_ value: CDWord)
}

extension CDWordList : Identifiable {

}
