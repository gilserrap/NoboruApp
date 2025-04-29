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
        VStack(spacing: Values.stackSpacing) {
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
                .font(.headline)
                .padding()
                .frame(maxWidth: .infinity)
                .background(Color.accentColor)
                .foregroundColor(.white)
                .cornerRadius(Values.buttonCornerRadius)
        }
        .animation(.easeInOut(duration: 0.3), value: viewModel.showAnswerResult)
        .opacity(viewModel.showAnswerResult ? 1 : 0)
        .disabled(!viewModel.showAnswerResult)
    }

    private var finishButton: some View {
        Button(action: {
            dismiss()
        }) {
            Text("Finish")
                .font(.headline)
                .foregroundColor(.white)
                .padding()
                .frame(maxWidth: .infinity)
                .background(Color.accentColor)
                .cornerRadius(Values.buttonCornerRadius)
        }
    }


    // MARK: - Sections

    private var progressSection: some View {
        Text("Question \(viewModel.currentQuestionIndex + 1) of \(viewModel.questions.count)")
            .font(.headline)
            .foregroundColor(.secondary)
    }

    private var questionSection: some View {
        let kanaCharacters = viewModel.currentQuestion.kanaText.map(String.init)
        return HStack(spacing: 8) {
            ForEach(0..<kanaCharacters.count, id: \.self) { index in
                VStack(spacing: 8) {
                    Text(kanaCharacters[index])
                        .font(.system(size: Values.questionFontSize, weight: .bold))

                    if viewModel.settings.showRomaji {
                        Text(convertKanaToRomaji(kana: kanaCharacters[index]))
                            .font(.system(size: Values.romajiFontSize))
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
        VStack(spacing: Values.choiceSpacing) {
            ForEach(0..<(viewModel.currentQuestion.options?.count ?? 0), id: \.self) { index in
                Button(action: {
                    viewModel.handleMultipleChoiceAnswer(index)
                }) {
                    Text(viewModel.currentQuestion.options?[index] ?? "")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(viewModel.buttonBackground(for: index))
                        .foregroundColor(.primary)
                        .cornerRadius(Values.buttonCornerRadius)
                }
                .disabled(viewModel.showAnswerResult)
            }
        }
    }

    private var freeInputSection: some View {
        VStack(spacing: Values.inputSpacing) {
            TextField("Type your answer", text: $viewModel.userInput)
                .textFieldStyle(.roundedBorder)
                .padding()

            Button(action: {
                viewModel.handleFreeInputAnswer()
            }) {
                Text("Submit")
                    .font(.headline)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.accentColor)
                    .foregroundColor(.white)
                    .cornerRadius(Values.buttonCornerRadius)
            }
            .disabled(viewModel.showAnswerResult || viewModel.userInput.isEmpty)
        }
    }

    // MARK: - Constants

    private struct Values {
        static let stackSpacing: CGFloat = 24
        static let questionFontSize: CGFloat = 48
        static let choiceSpacing: CGFloat = 16
        static let inputSpacing: CGFloat = 16
        static let buttonCornerRadius: CGFloat = 12
        static let romajiFontSize: CGFloat = 16
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
