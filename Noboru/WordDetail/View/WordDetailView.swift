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
                learningCard(
                    title: "Meaning",
                    content: viewModel.word.meaning,
                    color: .clear
                )
                VStack(spacing: 12) {
                    Label("Speak", systemImage: Images.speakLabel)
                        .font(Values.Font.header)
                        .foregroundColor(.primary)
                    HStack {
                        speakNormallyButton
                        speakCharacterByCharacterButton
                    }
                }
                .padding()
                .background(Values.Color.secondaryBackground)
                .cornerRadius(Values.Radius.container)
                learningCard(
                    title: "Hiragana",
                    content: viewModel.word.hiragana,
                    color: .pink
                )
                .padding(.top, 18)
                learningCard(
                    title: "Katakana",
                    content: viewModel.word.katakana,
                    color: .blue
                )
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
                    // Hiragana
                    Text(String(hiraganaChars[index]))
                        .font(.system(size: Values.FontSize.hiragana, weight: .bold))
                        .foregroundColor(viewModel.highlightedIndex == index ? .blue : .primary)
                        .scaleEffect(viewModel.highlightedIndex == index ? 1.2 : 1.0)

                    // Katakana
                    Text(String(katakanaChars[index]))
                        .font(.system(size: Values.FontSize.katakana, weight: .medium))
                        .foregroundColor(viewModel.highlightedIndex == index ? .blue : .secondary)
                        .scaleEffect(viewModel.highlightedIndex == index ? 1.1 : 1.0)

                    // Romaji
                    Text(romaji(for: hiraganaChars[index]))
                        .font(.caption)
                        .foregroundColor(viewModel.highlightedIndex == index ? .blue : .secondary)
                        .scaleEffect(viewModel.highlightedIndex == index ? 1.1 : 1.0)
                }
                .animation(.easeOut(duration: Values.Animation.highlight), value: viewModel.highlightedIndex)
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
                Values.Color.secondaryBackground
                color.opacity(Values.Opacity.cardTint)
            }
        }
        .cornerRadius(Values.Radius.card)
        .shadow(
            color: .black.opacity(Values.Opacity.cardShadow),
            radius: Values.Shadow.radius,
            x: 0,
            y: Values.Shadow.yOffset
        )
    }

    private var speakCharacterByCharacterButton: some View {
        Button(action: {
            viewModel.speakCharacterByCharacter()
        }) {
            HStack {
                Image(systemName: viewModel.isSpeaking ? Images.speakingActive : Images.slow)
                Text(viewModel.isSpeaking ? "Speaking..." : "Slow")
            }
            .font(Values.Font.button)
            .foregroundColor(.white)
            .padding()
        }
        .frame(maxWidth: .infinity)
        .background(Color.accentColor)
        .cornerRadius(Values.Radius.button)
    }

    private var speakNormallyButton: some View {
        Button(action: {
            viewModel.speakWordNormally()
        }) {
            HStack {
                Image(systemName: viewModel.isSpeaking ? Images.speakingActive : Images.normal)
                Text(viewModel.isSpeaking ? "Speaking..." : "Normal")
            }
            .font(Values.Font.button)
            .foregroundColor(.white)
            .padding()
        }
        .frame(maxWidth: .infinity)
        .background(Color.accentColor)
        .cornerRadius(Values.Radius.button)
    }

    // MARK: - Constants

    private struct Values {
        struct FontSize {
            static let hiragana: CGFloat = 48
            static let katakana: CGFloat = 32
        }

        struct Font {
            static let header: SwiftUI.Font = .headline
            static let button: SwiftUI.Font = .headline
        }

        struct Radius {
            static let button: CGFloat = 12
            static let card: CGFloat = 16
            static let container: CGFloat = 12
        }

        struct Color {
            static let secondaryBackground = SwiftUI.Color(uiColor: .secondarySystemBackground)
        }

        struct Opacity {
            static let cardTint: CGFloat = 0.1
            static let cardShadow: CGFloat = 0.05
        }

        struct Shadow {
            static let radius: CGFloat = 4
            static let yOffset: CGFloat = 2
        }

        struct Animation {
            static let highlight: Double = 0.2
        }
    }

    private struct Images {
        static let speakLabel = "speaker.wave.2.fill"
        static let speakingActive = "speaker.wave.2.circle.fill"
        static let slow = "tortoise.fill"
        static let normal = "speaker.wave.2.fill"
    }
}
