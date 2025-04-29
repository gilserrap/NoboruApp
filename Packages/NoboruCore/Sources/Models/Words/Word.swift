import Foundation

public struct Word: Identifiable, Codable {
    public var id: UUID
    public var romaji: String
    public var hiragana: String
    public var katakana: String
    public var meaning: String
    public var correctScript: ScriptType
    public var category: WordCategory

    public init(
        id: UUID,
        romaji: String,
        hiragana: String,
        katakana: String,
        meaning: String,
        correctScript: ScriptType,
        category: WordCategory
    ) {
        self.id = id
        self.romaji = romaji
        self.hiragana = hiragana
        self.katakana = katakana
        self.meaning = meaning
        self.correctScript = correctScript
        self.category = category
    }
}
