import Foundation
import AVFoundation
import NoboruCore
import Kana

@MainActor
public class WordDetailViewModel: NSObject, ObservableObject {
    public enum SpeechMode {
        case normal
        case characterByCharacter
    }

    @Published public var highlightedIndex: Int? = nil
    @Published public var isSpeaking: Bool = false
    @Published public var currentSpeechMode: SpeechMode = .normal

    public let word: Word
    private let synthesizer = AVSpeechSynthesizer()

    public init(word: Word) {
        self.word = word
        super.init()
        synthesizer.delegate = self

        warmupSynthesizer()
    }

    private func warmupSynthesizer() {
        let warmupUtterance = AVSpeechUtterance(string: Values.Speech.warmupText)
        warmupUtterance.voice = AVSpeechSynthesisVoice(language: Values.Speech.language)
        warmupUtterance.volume = Values.Speech.warmupVolume
        synthesizer.speak(warmupUtterance)
    }

    // MARK: - Speak Word Normally
    public func speakWordNormally() {
        highlightedIndex = nil
        currentSpeechMode = .normal

        let text = word.hiragana
        let utterance = AVSpeechUtterance(string: text)
        utterance.voice = AVSpeechSynthesisVoice(language: Values.Speech.language)
        utterance.rate = Values.Speech.rate

        isSpeaking = true
        synthesizer.speak(utterance)
    }

    // MARK: - Speak Character-by-Character
    public func speakCharacterByCharacter() {
        Task {
            isSpeaking = true
            currentSpeechMode = .characterByCharacter

            let characters = Array(word.hiragana)

            for (index, kana) in characters.enumerated() {
                highlightedIndex = index
                speakSingleKana(String(kana))

                try? await Task.sleep(nanoseconds: Values.Speech.delayBetweenKana)
            }

            highlightedIndex = nil
            isSpeaking = false
        }
    }

    private func speakSingleKana(_ kana: String) {
        let utterance = AVSpeechUtterance(string: kana)
        utterance.voice = AVSpeechSynthesisVoice(language: Values.Speech.language)
        utterance.rate = Values.Speech.rate
        synthesizer.speak(utterance)
    }

    // MARK: - Values
    private struct Values {
        struct Speech {
            static let language = "ja-JP"
            static let rate: Float = 0.2
            static let delayBetweenKana: UInt64 = 800_000_000 // nanoseconds
            static let warmupText = " "
            static let warmupVolume: Float = 0.0
        }
    }
}

// MARK: - AVSpeechSynthesizerDelegate
extension WordDetailViewModel: AVSpeechSynthesizerDelegate {
    nonisolated public func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didFinish utterance: AVSpeechUtterance) {
        DispatchQueue.main.async {
            if self.currentSpeechMode == .normal {
                self.highlightedIndex = nil
                self.isSpeaking = false
            }
        }
    }
}
