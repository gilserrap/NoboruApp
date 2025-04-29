import SwiftUI
import NoboruCore
import Kana

struct WordDetailView: View {
    @StateObject private var viewModel: WordDetailViewModel

    init(word: Word) {
        _viewModel = StateObject(wrappedValue: WordDetailViewModel(word: word))
    }

    var body: some View {
        ScrollView {
            VStack(spacing: 18) {
                Spacer()
                kanaHighlightLine
                learningCard(title: "Meaning", content: viewModel.word.meaning, color: .clear)
                VStack(spacing: 12) {
                    Label("Speak", systemImage: "speaker.wave.2.fill")
                        .font(.headline)
                        .foregroundColor(.primary)
                    HStack {
                        speakNormallyButton
                        speakCharacterByCharacterButton
                    }
                }
                .padding()
                .background(Color(uiColor: .secondarySystemBackground))
                .cornerRadius(12)
                learningCard(title: "Hiragana", content: viewModel.word.hiragana, color: .pink)
                    .padding(.top, 18)
                learningCard(title: "Katakana", content: viewModel.word.katakana, color: .blue)

                Spacer()
            }
            .padding()
        }
        .navigationTitle(viewModel.word.romaji)
        .navigationBarTitleDisplayMode(.inline)
    }

    private var kanaHighlightLine: some View {
        HStack(spacing: 8) {
            let hiraganaChars = Array(viewModel.word.hiragana)
            let katakanaChars = Array(viewModel.word.katakana)

            ForEach(hiraganaChars.indices, id: \.self) { index in
                VStack(spacing: 4) {
                    // Hiragana (top)
                    Text(String(hiraganaChars[index]))
                        .font(.system(size: 48, weight: .bold))
                        .foregroundColor(viewModel.highlightedIndex == index ? .blue : .primary)
                        .scaleEffect(viewModel.highlightedIndex == index ? 1.2 : 1.0)

                    // Katakana (middle)
                    Text(String(katakanaChars[index]))
                        .font(.system(size: 32, weight: .medium))
                        .foregroundColor(viewModel.highlightedIndex == index ? .blue : .secondary)
                        .scaleEffect(viewModel.highlightedIndex == index ? 1.1 : 1.0)

                    // Romaji (bottom)
                    Text(romaji(for: hiraganaChars[index]))
                        .font(.caption)
                        .foregroundColor(viewModel.highlightedIndex == index ? .blue : .secondary)
                        .scaleEffect(viewModel.highlightedIndex == index ? 1.1 : 1.0)
                }
                .animation(.easeOut(duration: 0.2), value: viewModel.highlightedIndex)
            }
        }
        .padding(.bottom, 10)
    }

    private func romaji(for kana: Character) -> String {
        Kana.toRomaji(of: String(kana), in: .hiragana) ?? "-"
    }


    private var romajiText: String {
        Kana.toRomaji(of: viewModel.word.hiragana, in: .hiragana) ?? "-"
    }

    @ViewBuilder
    private func learningCard(title: String, content: String, color: Color) -> some View {
        VStack(spacing: 6) {
            Text(title)
                .font(.caption)
                .foregroundColor(.secondary)
            Text(content)
                .font(.title3)
                .multilineTextAlignment(.center)
                .padding(.vertical, 6)
        }
        .frame(maxWidth: .infinity)
        .padding()
        .background {
            ZStack {
                Color(uiColor: .secondarySystemBackground)
                color.opacity(0.1)
            }
        }
        .cornerRadius(16)
        .shadow(color: .black.opacity(0.05), radius: 4, x: 0, y: 2)
    }

    private var speakCharacterByCharacterButton: some View {
        Button(action: {
            viewModel.speakCharacterByCharacter()
        }) {
            HStack {
                Image(systemName: viewModel.isSpeaking ? "speaker.wave.2.circle.fill" : "tortoise.fill")
                Text(viewModel.isSpeaking ? "Speaking..." : "Slow")
            }
            .font(.headline)
            .foregroundColor(.white)
            .padding()
        }
        .frame(maxWidth: .infinity)
        .background(Color.accentColor)
        .cornerRadius(12)
    }

    private var speakNormallyButton: some View {
        Button(action: {
            viewModel.speakWordNormally()
        }) {
            HStack {
                Image(systemName: viewModel.isSpeaking ? "speaker.wave.2.circle.fill" : "speaker.wave.2.fill")
                Text(viewModel.isSpeaking ? "Speaking..." : "Normal")
            }
            .font(.headline)
            .foregroundColor(.white)
            .padding()
        }
        .frame(maxWidth: .infinity)
        .background(Color.accentColor)
        .cornerRadius(12)
    }
}
