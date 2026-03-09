import Foundation
import SwiftUI
import Combine


enum TodoListRoute: Identifiable {
    case add
    case view(TodoItem)
    case edit(TodoItem)
    
    var id: String {
        switch self {
        case .add: return "add"
        case .view(let item): return "view-\(item.id)"
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
    
    func showViewTask(_ item: TodoItem) {
        presentedRoute = .view(item)
    }
    
    func showEditTask(_ item: TodoItem) {
        presentedRoute = .edit(item)
    }
    
    func dismiss() {
        presentedRoute = nil
    }
}

