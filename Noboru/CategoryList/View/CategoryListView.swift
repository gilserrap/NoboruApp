import SwiftUI
import Additions
import NoboruCore

struct CategoryListView: View {

    @StateObject private var viewModel = CategoryListViewModel()
    @State var quizStarted: Bool = false

    var body: some View {
        List(WordCategory.allCases, id: \.self) { category in
            NavigationLink(destination: WordListView(category: category, words: viewModel.words(for: category))) {
                HStack {
                    VStack(alignment: .leading) {
                        Text(category.displayName)
                            .font(.headline)
                        Text("\(viewModel.words(for: category).count) words")
                            .font(.caption)
                            .foregroundColor(.gray)
                    }
                    Spacer()
                    categoryIcon(for: category)
                        .font(.title2)
                }
            }
        }
        .navigationTitle("Noboru 📚")
        .task {
            await viewModel.loadWords()
        }
    }

    private func categoryIcon(for category: WordCategory) -> some View {
        switch category {
        case .action:
            return Text("🏃‍♂️")
        case .hold:
            return Text("🪨")
        case .gear:
            return Text("🎒")
        case .excuse:
            return Text("😅")
        case .location:
            return Text("🗻")
        }
    }
}

#Preview {
    CategoryListView()
        .injecting {
            Register(WordServiceable.self) { WordService() }
        }
}
