//
//  TodoListApp.swift
//  TodoList
//
//  Created by Дионисий Коневиченко on 06.03.2026.
//

import SwiftUI
import CoreData

@main
struct TodoListApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
