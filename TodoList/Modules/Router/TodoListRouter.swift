//
//  TodoListRouter.swift
//  TodoList
//
//  Created by Дионисий Коневиченко on 06.03.2026.
//

import Foundation
import SwiftUI
import Combine


enum TodoListRoute: Identifiable {
    case add
    case edit(TodoItem)
    
    
    var id: String {
        switch self {
        case .add: return "add"
        case .edit(let item): return "edit-\(item.id)"
        }
    }
}


final class TodoListRouter: TodoListRouterProtocol, ObservableObject {
    // Если не nil - показать sheet (add или edit)
    @Published var presentedRoute: TodoListRoute?
    
    
    func showAddTask() {
        presentedRoute = .add
    }
    
    func showEditTask(_ item: TodoItem) {
        presentedRoute = .edit(item)
    }
    
    func dismiss() {
        presentedRoute = nil
    }
}

