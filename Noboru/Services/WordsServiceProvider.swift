import Additions
import NoboruCore

class WordsServiceProvider: ServiceProvider {
    func modules() -> [Additions.Register] {
        [
            Register(WordServiceable.self) { WordService() }

        ]
    }
    var plugins: [any AppLifecyclePluginable] = []
    var operations: [AsyncOperation] = []
}
