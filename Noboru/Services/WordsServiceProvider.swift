import Additions
import NoboruCore

class WordsServiceProvider: ServiceProvider {
    func modules() -> [Additions.Register] {
        [
            Register(WordServiceable.self, .unique) { WordService() },
            Register(LocalWordDataSourceable.self) { LocalWordDataSource() },
            Register(RemoteWordDataSourceable.self) { RemoteWordDataSource() },
        ]
    }
    var plugins: [any AppLifecyclePluginable] = []
    var operations: [AsyncOperation] = []
}
