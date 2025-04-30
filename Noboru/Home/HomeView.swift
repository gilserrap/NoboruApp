import SwiftUI

struct HomeView: View {
    @State private var showQuizSettings = false
    @State private var showCategoryList = false

    var body: some View {
        NavigationStack {
            VStack(spacing: 32) {
                Spacer()

                Text("Noboru")
                    .font(.largeTitle)
                    .bold()

                VStack(spacing: 16) {
                    Button(action: {
                        showQuizSettings = true
                    }) {
                        Text("Start Quiz")
                            .font(.title2)
                            .foregroundColor(.white)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color.blue)
                            .cornerRadius(16)
                    }

                    Button(action: {
                        showCategoryList = true
                    }) {
                        Text("Study Words")
                            .font(.title2)
                            .foregroundColor(.white)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color.green)
                            .cornerRadius(16)
                    }
                }
                .padding(.horizontal)

                Spacer()
            }
            .padding()
            .navigationDestination(isPresented: $showQuizSettings) {
                QuizSettingsView()
            }
            .navigationDestination(isPresented: $showCategoryList) {
                CategoryListView()
            }
        }
    }
}

#Preview {
    HomeView()
}
