import SwiftUI
import Additions

@main
struct NoboruApp: App {
    private let serviceProviders: [ServiceProvider] = [
        QuizServiceProvider(),
        WordsServiceProvider(),
    ]

    var body: some Scene {
        WindowGroup {
            NavigationView {
                HomeView()
            }.task {
                AppPlugins.shared.build(serviceProviders: serviceProviders) {
                    print("Services initialised")
                }
            }
        }
    }
}
