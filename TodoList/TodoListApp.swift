import SwiftUI
import CoreData

@main
struct TodoListApp: App {
    let coreDataStack = CoreDataStack.shared
    
    var body: some Scene {
        WindowGroup {
            TodoListModule.build()
        }
    }
}
