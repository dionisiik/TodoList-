
import Foundation
@testable import TodoList


final class MockDummyJSONTodoService: DummyJSONTodoServiceProtocol {
    
    var fetchTodosResult: Result<[DummyTodoModel], Error> = .success([])
    var fetchTodosCallCount = 0
    
    
    func fetchTodos(completion: @escaping (Result<[DummyTodoModel], Error>) -> Void) {
        fetchTodosCallCount += 1
        completion(fetchTodosResult)
    }
}
