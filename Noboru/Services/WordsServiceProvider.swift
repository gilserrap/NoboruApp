import CoreData
import Additions
import NoboruCore

class WordsServiceProvider: ServiceProvider {
    let persistenceController = PersistenceController()

    func modules() -> [Additions.Register] {
        [
            Register(WordServiceable.self, .unique) { WordService() },
            Register(InMemoryWordDataSourceable.self) { InMemoryWordDataSource() },
            Register(RemoteWordDataSourceable.self) { RemoteWordDataSource() },
            Register(CoreDataWordDataSourceable.self) { CoreDataWordDataSource() },
            Register(NSManagedObjectContext.self) { self.persistenceController.context }
        ]
    }
    var plugins: [any AppLifecyclePluginable] = []
    var operations: [AsyncOperation] = []
}
