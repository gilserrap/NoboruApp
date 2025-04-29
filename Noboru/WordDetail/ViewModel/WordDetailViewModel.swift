import Foundation
import AVFoundation
import NoboruCore
import Kana

// Speech mode types
public enum SpeechMode {
    case normal
    case characterByCharacter
}

@MainActor
public class WordDetailViewModel: NSObject, ObservableObject {
    @Published public var highlightedIndex: Int? = nil
    @Published public var isSpeaking: Bool = false
    @Published public var currentSpeechMode: SpeechMode = .normal

    public let word: Word
    private let synthesizer = AVSpeechSynthesizer()

    public init(word: Word) {
        self.word = word
        super.init()
        synthesizer.delegate = self

        // Prewarm synthesizer to avoid first-play delay
        let warmupUtterance = AVSpeechUtterance(string: " ")
        warmupUtterance.voice = AVSpeechSynthesisVoice(language: "ja-JP")
        warmupUtterance.volume = 0.0
        synthesizer.speak(warmupUtterance)
    }

    // MARK: - Speak Word Normally (No highlighting)
    public func speakWordNormally() {
        highlightedIndex = nil
        currentSpeechMode = .normal

        let text = word.hiragana
        let utterance = AVSpeechUtterance(string: text)
        utterance.voice = AVSpeechSynthesisVoice(language: "ja-JP")
        utterance.rate = 0.2

        isSpeaking = true
        synthesizer.speak(utterance)
    }

    // MARK: - Speak Character-by-Character (With highlighting)
    public func speakCharacterByCharacter() {
        Task {
            isSpeaking = true
            currentSpeechMode = .characterByCharacter

            let characters = Array(word.hiragana)

            for (index, kana) in characters.enumerated() {
                highlightedIndex = index
                speakSingleKana(String(kana))

                try? await Task.sleep(nanoseconds: 800_000_000) // 0.8 seconds between kana
            }

            highlightedIndex = nil
            isSpeaking = false
        }
    }

    private func speakSingleKana(_ kana: String) {
        let utterance = AVSpeechUtterance(string: kana)
        utterance.voice = AVSpeechSynthesisVoice(language: "ja-JP")
        utterance.rate = 0.2
        synthesizer.speak(utterance)
    }
}

// MARK: - AVSpeechSynthesizerDelegate
extension WordDetailViewModel: AVSpeechSynthesizerDelegate {

    nonisolated public func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, willSpeakRangeOfSpeechString characterRange: NSRange, utterance: AVSpeechUtterance) {
        //
    }

    nonisolated public func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didFinish utterance: AVSpeechUtterance) {
        DispatchQueue.main.async {
            if self.currentSpeechMode == .normal {
                self.highlightedIndex = nil
                self.isSpeaking = false
            }
        }
    }
}
