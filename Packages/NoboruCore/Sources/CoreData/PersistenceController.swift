import CoreData

public protocol ManagedObjectContextProvider {
    var context: NSManagedObjectContext { get }
}

public struct PersistenceController: ManagedObjectContextProvider {

    public var context: NSManagedObjectContext {
        container.viewContext
    }

    public let container: NSPersistentContainer

    public init(inMemory: Bool = false) {
        // Load the model from the Swift Package bundle
        guard let modelURL = Bundle.module.url(forResource: "NoboruModel", withExtension: "momd"),
              let model = NSManagedObjectModel(contentsOf: modelURL) else {
            fatalError("Failed to load Core Data model from module bundle.")
        }

        container = NSPersistentContainer(name: "NoboruModel", managedObjectModel: model)

        if inMemory {
            container.persistentStoreDescriptions.first?.url = URL(fileURLWithPath: "/dev/null")
        }

        container.loadPersistentStores { description, error in
            if let error = error {
                fatalError("Failed to load Core Data store: \(error)")
            }
        }

        container.viewContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
        container.viewContext.automaticallyMergesChangesFromParent = true
    }
}
