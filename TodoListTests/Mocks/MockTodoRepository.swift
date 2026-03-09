
import Foundation
@testable import TodoList

final class MockTodoRepository: TodoRepositoryProtocol {
    
    var fetchAllResult: Result<[TodoItem], Error> = .success([])
    var addResult: Result<TodoItem, Error>?
    var updateResult: Result<Void, Error> = .success(())
    var deleteResult: Result<Void, Error> = .success(())
    var searchResult: Result<[TodoItem], Error> = .success([])
    
    
    var fetchAllCallCount = 0
    var addCallCount = 0
    var addedTittles: [String] = []
    var deleteCallCount = 0
    var lastDeletedId: Int32?
    var searchCallCount = 0
    var lastSearchQuery: String?
    
    func fetchAll(completion: @escaping (Result<[TodoItem], Error>) -> Void) {
        fetchAllCallCount += 1
        completion(fetchAllResult)
    }
    
    func add(title: String, taskDescription: String?, completed: Bool, completion: @escaping (Result<TodoItem, Error>) -> Void) {
        addCallCount += 1
        addedTittles.append(title)
        let item = TodoItem (id: Int32(addCallCount), title: title,
                             taskDescription: taskDescription, createdAt: Date(), completed: completed)
        completion (addResult ?? .success(item))
    }
    
    func update(_ item: TodoItem, completion: @escaping (Result<Void, Error>) -> Void) {
        completion(updateResult)
    }
    
    func delete(id: Int32, completion: @escaping (Result<Void, Error>) -> Void) {
        deleteCallCount += 1
        lastDeletedId = id
        completion(deleteResult)
    }
    
    
    func search(query: String, completion: @escaping (Result<[TodoItem], Error>) -> Void) {
        searchCallCount += 1
        lastSearchQuery = query
        completion(searchResult)
    }
}



