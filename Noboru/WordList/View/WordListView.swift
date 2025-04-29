import SwiftUI
import NoboruCore

struct WordListView: View {
    var category: WordCategory
    var words: [Word]

    @State private var searchText: String = ""

    var filteredWords: [Word] {
        if searchText.isEmpty {
            return words
        } else {
            return words.filter {
                $0.romaji.localizedCaseInsensitiveContains(searchText) ||
                $0.hiragana.localizedCaseInsensitiveContains(searchText) ||
                $0.katakana.localizedCaseInsensitiveContains(searchText) ||
                $0.meaning.localizedCaseInsensitiveContains(searchText)
            }
        }
    }

    var body: some View {
        List(filteredWords) { word in
            NavigationLink(destination: WordDetailView(word: word)) {
                VStack(alignment: .leading, spacing: 4) {
                    Text(word.hiragana)
                        .font(.title2)
                        .bold()
                    HStack {
                        Text(word.romaji)
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                        Spacer()
                        Text(word.meaning)
                            .font(.subheadline)
                            .foregroundColor(.primary)
                    }
                }
                .padding(.vertical, 4)
            }
        }
        .navigationTitle(category.displayName)
        .searchable(text: $searchText)
    }
}
