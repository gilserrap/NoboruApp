import SwiftUI
import NoboruCore
import Kana

struct QuizView: View {
    @Environment(\.dismiss) private var dismiss
    @StateObject private var viewModel: QuizViewModel

    init(settings: QuizSettings) {
        _viewModel = StateObject(wrappedValue: QuizViewModel(settings: settings))
    }

    internal init(viewModel: QuizViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }

    var body: some View {
        VStack(spacing: 24) {
            if viewModel.finished {
                QuizSummaryView(summary: viewModel.quizSummary)
                finishButton
            } else if viewModel.currentQuestionIndex < viewModel.questions.count {
                progressSection
                Spacer()
                questionSection
                Spacer()
                if viewModel.settings.mode == .multipleChoice {
                    multipleChoiceSection
                } else {
                    freeInputSection
                }
                Spacer()
                nextButton
            }
        }
        .padding()
        .navigationTitle("Quiz")
    }

    // MARK: - Buttons

    private var nextButton: some View {
        Button(action: {
            viewModel.goToNextQuestion()
        }) {
            Text("Next")
                .font(Values.Font.button)
                .padding()
                .frame(maxWidth: .infinity, minHeight: Values.Button.height)
                .background(Color.accentColor)
                .foregroundColor(.white)
                .cornerRadius(Values.Button.cornerRadius)
        }
        .animation(.easeInOut(duration: Values.Button.animationDuration), value: viewModel.showAnswerResult)
        .opacity(viewModel.showAnswerResult ? 1 : 0)
        .disabled(!viewModel.showAnswerResult)
    }

    private var finishButton: some View {
        Button(action: {
            dismiss()
        }) {
            Text("Finish")
                .font(Values.Font.button)
                .foregroundColor(.white)
                .padding()
                .frame(maxWidth: .infinity, minHeight: Values.Button.height)
                .background(Color.accentColor)
                .cornerRadius(Values.Button.cornerRadius)
        }
    }

    // MARK: - Sections

    private var progressSection: some View {
        Text("Question \(viewModel.currentQuestionIndex + 1) of \(viewModel.questions.count)")
            .font(Values.Font.progress)
            .foregroundColor(.secondary)
    }

    private var questionSection: some View {
        let kanaCharacters = viewModel.currentQuestion.kanaText.map(String.init)
        return HStack(spacing: 16) {
            ForEach(0..<kanaCharacters.count, id: \.self) { index in
                VStack(spacing: 8) {
                    Text(kanaCharacters[index])
                        .font(.system(size: Values.FontSize.question, weight: .bold))

                    if viewModel.settings.showRomaji {
                        Text(convertKanaToRomaji(kana: kanaCharacters[index]))
                            .font(.system(size: Values.FontSize.romaji))
                            .foregroundColor(.secondary)
                    }
                }
            }
        }
    }

    private func convertKanaToRomaji(kana: String) -> String {
        if let fromHiragana = Kana.toRomaji(of: kana, in: .hiragana) {
            return fromHiragana
        }
        if let fromKatakana = Kana.toRomaji(of: kana, in: .katakana) {
            return fromKatakana
        }
        return "?"
    }

    private var multipleChoiceSection: some View {
        VStack(spacing: 16) {
            ForEach(0..<(viewModel.currentQuestion.options?.count ?? 0), id: \.self) { index in
                Button(action: {
                    viewModel.handleMultipleChoiceAnswer(index)
                }) {
                    Text(viewModel.currentQuestion.options?[index] ?? "")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(buttonBackground(for: index))
                        .foregroundColor(.primary)
                        .cornerRadius(Values.Button.cornerRadius)
                }
                .disabled(viewModel.showAnswerResult)
            }
        }
    }

    private func buttonBackground(for index: Int) -> Color {
        guard viewModel.showAnswerResult else {
            return Values.Color.neutral
        }

        if index == viewModel.currentQuestion.options?.firstIndex(of: viewModel.currentQuestion.correctAnswer) {
            return Values.Color.correct
        } else if index == viewModel.selectedAnswerIndex {
            return Values.Color.incorrect
        } else {
            return Values.Color.neutral
        }
    }

    private var freeInputSection: some View {
        VStack(spacing: 16) {
            TextField("Type your answer", text: $viewModel.userInput)
                .textFieldStyle(.roundedBorder)
                .padding()

            Button(action: {
                viewModel.handleFreeInputAnswer()
            }) {
                Text("Submit")
                    .font(Values.Font.button)
                    .frame(maxWidth: .infinity, minHeight: Values.Button.height)
                    .padding()
                    .background(Color.accentColor)
                    .foregroundColor(.white)
                    .cornerRadius(Values.Button.cornerRadius)
            }
            .disabled(viewModel.showAnswerResult || viewModel.userInput.isEmpty)
        }
    }

    // MARK: - Constants
    private struct Values {
        struct FontSize {
            static let question: CGFloat = 48
            static let romaji: CGFloat = 16
        }

        struct Font {
            static let button: SwiftUI.Font = .headline
            static let progress: SwiftUI.Font = .headline
        }

        struct Button {
            static let cornerRadius: CGFloat = 12
            static let height: CGFloat = 44
            static let animationDuration: Double = 0.3
        }

        struct Color {
            static let correct = SwiftUI.Color.green.opacity(0.6)
            static let incorrect = SwiftUI.Color.red.opacity(0.6)
            static let neutral = SwiftUI.Color(UIColor.secondarySystemBackground)
        }
    }
}


#Preview("Multiple Choice Mode") {
    NavigationStack {
        QuizView(settings: QuizSettings(
            script: .hiragana,
            category: .hold,
            mode: .multipleChoice,
            showRomaji: true
        ))
    }
}

#Preview("Free Input Mode") {
    NavigationStack {
        QuizView(settings: QuizSettings(
            script: .katakana,
            category: .action,
            mode: .freeInput,
            showRomaji: false
        ))
    }
}
