import XCTest
@testable import TodoList

final class MockTodoListInteractor: TodoListInteractorProtocol {
    var loadTodosCompletion: ((Result<[TodoItem], Error>) -> Void)?
    var addCompletion: ((Result<TodoItem, Error>) -> Void)?
    var updateCompletion: ((Result<Void, Error>) -> Void)?
    var deleteCompletion: ((Result<Void, Error>) -> Void)?
    var searchCompletion: ((Result<[TodoItem], Error>) -> Void)?
    
    var loadTodosCallCount = 0
    var addCallCount = 0
    var updateCallCount = 0
    var deleteCallCount = 0
    var searchCallCount = 0
    
    var lastAddTitle: String?
    var lastAddTaskDescription: String?
    var lastDeleteId: Int32?
    var lastSearchQuery: String?
    var lastUpdateItem: TodoItem?
    
    
    func loadTodos(completion: @escaping (Result<[TodoItem], Error>) -> Void) {
        loadTodosCallCount += 1
        loadTodosCompletion = completion
    }
    
    
    func add(title: String, taskDescription: String?, completed: Bool, completion: @escaping (Result<TodoItem, Error>) -> Void) {
        addCallCount += 1
        lastAddTitle = title
        lastAddTaskDescription = taskDescription
        addCompletion = completion
    }
    
    func update(_ item: TodoItem, completion: @escaping (Result<Void, Error>) -> Void) {
        updateCallCount += 1
        lastUpdateItem = item
        updateCompletion = completion
    }
    
    func delete(id: Int32, completion: @escaping (Result<Void, Error>) -> Void) {
        deleteCallCount += 1
        lastDeleteId = id
        deleteCompletion = completion
    }
    
    func search(query: String, completion: @escaping (Result<[TodoItem], Error>) -> Void) {
        searchCallCount += 1
        lastSearchQuery = query
        searchCompletion = completion
    }
}
