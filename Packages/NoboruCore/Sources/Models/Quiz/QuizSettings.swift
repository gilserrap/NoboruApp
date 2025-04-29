import Foundation

public struct QuizSettings: Codable, Equatable {
    public let script: QuizScriptOption
    public let category: WordCategory
    public let mode: QuizMode
    public let showRomaji: Bool

    public init(script: QuizScriptOption, category: WordCategory, mode: QuizMode, showRomaji: Bool) {
        self.script = script
        self.category = category
        self.mode = mode
        self.showRomaji = showRomaji
    }
}

