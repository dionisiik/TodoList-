//
//  TodoListModule.swift
//  TodoList
//
//  Created by Дионисий Коневиченко on 06.03.2026.
//

import SwiftUI
import CoreData

enum TodoListModule {
    static func build() -> some View {
        let context = CoreDataStack.shared.viewContext
        let repository = CoreDataTodoRepository(context: context)
        let apiService = DummyJSONTodoService()
        let interactor = TodoListInteractor(repository: repository, apiService: apiService)
        let router = TodoListRouter()
        let presenter = TodoListPresenter(interactor: interactor, router: router)
        return TodoListView(presenter: presenter, router: router)
    }
}
