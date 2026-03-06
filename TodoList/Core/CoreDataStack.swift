//
//  CoreDataStack.swift
//  TodoList
//
//  Created by Дионисий Коневиченко on 06.03.2026.
//

import CoreData


final class CoreDataStack {
    static let shared = CoreDataStack()
    
    private let container: NSPersistentContainer
    
    var viewContext: NSManagedObjectContext {
        container.viewContext
    }
    
    func newBackgroundContext() -> NSManagedObjectContext {
        container.newBackgroundContext()
    }
    
    private init(inMemory: Bool = false) {
        container = NSPersistentContainer(name: "TodoList")
        if inMemory {
            container.persistentStoreDescriptions.first?.url = URL(fileURLWithPath: "/dev/null")
        }
        container.loadPersistentStores { _, error in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
                
            }
        }
        container.viewContext.automaticallyMergesChangesFromParent = true
        
    }
}
