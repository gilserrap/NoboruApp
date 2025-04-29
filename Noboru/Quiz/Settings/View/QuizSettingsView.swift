import SwiftUI
import NoboruCore

struct QuizSettingsView: View {

    @State private var selectedScript: ScriptOption = .hiragana
    @State private var selectedCategory: WordCategory = .hold
    @State private var selectedQuizMode: QuizMode = .multipleChoice
    @State private var showRomaji: Bool = true
    @State private var startQuiz: Bool = false

    var body: some View {
        NavigationStack {
            Form {
                previewSection
                alphabetSection
                categorySection
                modeSection
                optionsSection
                startButtonSection
            }
            .navigationTitle("Quiz Settings")
            .fullScreenCover(isPresented: $startQuiz) {
                QuizView(settings: QuizSettings(
                    script: selectedScript,
                    category: selectedCategory,
                    mode: selectedQuizMode,
                    showRomaji: showRomaji
                ))
            }
        }
    }

    // MARK: - Sections

    private var previewSection: some View {
        Section(header: Text("Preview")) {
            HStack(spacing: Values.characterSpacing) {
                ForEach(previewCharacters.indices, id: \.self) { index in
                    VStack(spacing: Values.previewVStackSpacing) {
                        Text(previewCharacters[index])
                            .font(.system(size: Values.characterFontSize, weight: .bold))

                        if showRomaji {
                            Text(previewRomaji[index])
                                .font(.system(size: Values.romajiFontSize))
                                .foregroundColor(.secondary)
                        }
                    }
                }
            }
            .padding(.vertical, Values.previewVerticalPadding)
        }
    }

    private var alphabetSection: some View {
        Section(header: Text("Alphabet")) {
            Picker("Choose Alphabet", selection: $selectedScript) {
                ForEach(ScriptOption.allCases, id: \.self) { option in
                    Text(option.displayName).tag(option)
                }
            }
            .pickerStyle(.menu)
        }
    }

    private var categorySection: some View {
        Section(header: Text("Category")) {
            Picker("Choose Category", selection: $selectedCategory) {
                ForEach(WordCategory.allCases, id: \.self) { category in
                    Text(category.rawValue.capitalized).tag(category)
                }
            }
            .pickerStyle(.menu)
        }
    }

    private var modeSection: some View {
        Section(header: Text("Quiz Mode")) {
            Picker("Choose Mode", selection: $selectedQuizMode) {
                ForEach(QuizMode.allCases, id: \.self) { mode in
                    Text(mode.displayName).tag(mode)
                }
            }
            .pickerStyle(.segmented)
        }
    }

    private var optionsSection: some View {
        Section(header: Text("Display Options")) {
            Toggle("Show Romaji", isOn: $showRomaji)
        }
    }

    private var startButtonSection: some View {
        Section {
            Button("Start Quiz") {
                startQuiz = true
            }
            .font(.headline)
            .frame(maxWidth: .infinity, alignment: .center)
        }
    }

    // MARK: - Preview Data

    private var previewCharacters: [String] {
        switch selectedScript {
        case .hiragana, .correct:
            return ["の", "ぼ", "る"]
        case .katakana:
            return ["ノ", "ボ", "ル"]
        }
    }

    private var previewRomaji: [String] {
        return ["no", "bo", "ru"]
    }

    // MARK: - Constants

    private struct Values {
        static let characterSpacing: CGFloat = 8
        static let previewVStackSpacing: CGFloat = 4
        static let previewVerticalPadding: CGFloat = 8
        static let characterFontSize: CGFloat = 32
        static let romajiFontSize: CGFloat = 12
    }
}

#Preview {
    NavigationStack {
        QuizSettingsView()
    }
}
