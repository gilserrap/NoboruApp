import Foundation
import CoreData

@objc(CDWord)
public class CDWord: NSManagedObject {

}

extension CDWord {
    func toDomain() -> Word {
        Word(
            id: self.id ?? UUID(),
            romaji: self.romaji ?? "",
            hiragana: self.hiragana ?? "",
            katakana: self.katakana ?? "",
            meaning: self.meaning ?? "",
            correctScript: WordScriptType(rawValue: self.correctScript ?? "") ?? .hiragana,
            category: WordCategory(rawValue: self.category ?? "") ?? .action
        )
    }
}
