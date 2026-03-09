import XCTest
@testable import TodoList

final class MockTodoListRouter: TodoListRouterProtocol {
    
    var showAddTaskCallCount = 0
    var showEditTaskCallCount = 0
    var showViewTaskCallCount = 0
    var dismissCallCount = 0
    var lastEditItem: TodoItem?
    var lastViewItem: TodoItem?
    
    func showAddTask() {
        showAddTaskCallCount += 1
    }
    
    func showViewTask(_ item: TodoItem) {
        showViewTaskCallCount += 1
        lastViewItem = item
    }
    
    func showEditTask(_ item: TodoItem) {
        showEditTaskCallCount += 1
        lastEditItem = item
    }
    
    
    func dismiss() {
        dismissCallCount += 1
    }
}
