import Additions
import NoboruCore

class QuizServiceProvider: ServiceProvider {
    func modules() -> [Additions.Register] {
        [
            Register(QuizServiceable.self) { QuizService() }
        ]
    }
    var plugins: [any AppLifecyclePluginable] = []
    var operations: [AsyncOperation] = []
}
