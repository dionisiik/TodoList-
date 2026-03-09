import XCTest
@testable import TodoList

final class TodoListInteractorTests: XCTestCase {
    
    private var repository: MockTodoRepository!
    private var apiService: MockDummyJSONTodoService!
    private var sut: TodoListInteractor!
    
    private let userDefaultsKey = "TodoList.hasLoadedFromAPI"
    
    override func setUp()  {
        super.setUp()
        repository = MockTodoRepository()
        apiService = MockDummyJSONTodoService()
        sut = TodoListInteractor(repository: repository, apiService: apiService)
        UserDefaults.standard.removeObject(forKey: userDefaultsKey)
    }
    
    override func tearDown() {
        UserDefaults.standard.removeObject(forKey: userDefaultsKey)
        sut = nil
        apiService = nil
        repository = nil
        super.tearDown()
        
    }
    
    func test_loadTodos_firstLaunch_callsAPIAndSavesToRepository() {
        let dtos = [
            DummyTodoModel(id: 1, todo: "First", completed: false, userId: 1),
            DummyTodoModel(id: 2, todo: "Second", completed: true, userId: 1)
        ]
        apiService.fetchTodosResult = .success(dtos)
        
        let expectedItems = [
            TodoItem(id: 1, title: "First", taskDescription: nil, createdAt: Date(), completed: false),
            TodoItem(id: 2, title: "Second", taskDescription: nil, createdAt: Date(), completed: true)
        ]
        repository.fetchAllResult = .success(expectedItems)
        
        let exp = expectation(description: "loadTodos first launch")
        sut.loadTodos { result in
            switch result {
            case .success(let items):
                XCTAssertEqual(items.count, 2)
            case .failure(let error):
                XCTFail("Expected success, got \(error)")
            }
            exp.fulfill()
        }
        wait(for: [exp], timeout: 2.0)
        
        XCTAssertEqual(apiService.fetchTodosCallCount, 1)
        XCTAssertEqual(repository.addCallCount, 2)
        XCTAssertEqual(repository.addedTittles, ["First", "Second"])
        XCTAssertEqual(repository.fetchAllCallCount, 1)
        XCTAssert(UserDefaults.standard.bool(forKey: userDefaultsKey))
    }
    
    
    func test_loadTodos_secondLaunch_skipsAPIAndCallsOnlyRepository() {
        UserDefaults.standard.set(true, forKey: userDefaultsKey)
        
        let storedItems = [
            TodoItem(id: 10, title: "Stored", taskDescription: nil, createdAt: Date(), completed: false)
        ]
        repository.fetchAllResult = .success(storedItems)
        
        let exp = expectation(description: "loadTodos second launch")
        sut.loadTodos { result in
            switch result {
            case .success(let items):
                XCTAssertEqual(items.count, 1)
                XCTAssertEqual(items.first?.title, "Stored")
            case .failure(let error):
                XCTFail("Expected success, got \(error)")
            }
            exp.fulfill()
        }
        wait(for: [exp], timeout: 2.0)
        
        XCTAssertEqual(apiService.fetchTodosCallCount, 0)
        XCTAssertEqual(repository.fetchAllCallCount, 1)
    }
    
    
    func test_add_delegatesToRepository() {
        let exp = expectation(description: "add")
        sut.add(title: "New task", taskDescription: "Details", completed: false) { result in
            switch result {
            case .success(let item):
                XCTAssertEqual(item.title, "New task")
            case .failure(let error):
                XCTFail("Expected success, got \(error)")
            }
            exp.fulfill()
        }
        wait(for: [exp], timeout: 2.0)
        
        XCTAssertEqual(repository.addCallCount, 1)
        XCTAssertEqual(repository.addedTittles, ["New task"])
    }
    
    func test_delete_delegatesToRepository() {
        let exp = expectation(description: "delete")
        sut.delete(id: 7) { result in
            switch result {
            case .success:
                break
            case .failure(let error):
                XCTFail("Expected success, got \(error)")
            }
            exp.fulfill()
        }
        wait(for: [exp], timeout: 2.0)
        
        XCTAssertEqual(repository.deleteCallCount, 1)
        XCTAssertEqual(repository.lastDeletedId, 7)
    }
}
