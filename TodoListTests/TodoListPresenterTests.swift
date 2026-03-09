import XCTest
@testable import TodoList



final class TodoListPresenterTests: XCTestCase {
    private var interactor: MockTodoListInteractor!
    private var router: MockTodoListRouter!
    private var sut: TodoListPresenter!
    
    override func setUp() {
        super.setUp()
        interactor = MockTodoListInteractor()
        router = MockTodoListRouter()
        sut = TodoListPresenter(interactor: interactor, router: router)
    }
    
    override func tearDown() {
        interactor = nil
        router = nil
        sut = nil
        super.tearDown()
    }
    
    
    
    
    func test_loadtodos_success_updatesItemsAndClearsLoading() {
        let expected = [makeTodoItem(id: 1, title: "A"), makeTodoItem(id: 2, title: "B")]
        let exp = expectation(description: "loadTodos completion")
        
        
        sut.loadTodos()
        XCTAssertTrue(sut.isLoading)
        
        DispatchQueue.main.async {
            self.interactor.loadTodosCompletion?(.success(expected))
        }
        
        DispatchQueue.main.async {
            exp.fulfill()
        }
        wait(for: [exp], timeout: 1.0)
        
        XCTAssertFalse(sut.isLoading)
        XCTAssertEqual(sut.items.count, 2)
        XCTAssertEqual(sut.items.map(\.title), ["A", "B"])
        XCTAssertNil(sut.errorMessage)
    }
    
    func test_loadtodos_failure_setsErrorMessage() {
        let exp = expectation(description: "loadTodos failure")
        let error = NSError(domain: "test", code: -1, userInfo: [NSLocalizedDescriptionKey: "Network error"])
        
        sut.loadTodos()
        DispatchQueue.main.async {
            self.interactor.loadTodosCompletion?(.failure(error))
        }
        DispatchQueue.main.async { exp.fulfill()}
        wait(for: [exp], timeout: 1.0)
        
        XCTAssertFalse(sut.isLoading)
        XCTAssertEqual(sut.errorMessage, "Network error")
    }
    func test_submitNewTask_emptyTitle_doesNotCallInteractor() {
        sut.submitNewTask(title: "   ", taskDescription: nil)
        sut.submitNewTask(title: "", taskDescription: nil)
        
        XCTAssertEqual(interactor.addCallCount, 0)
    }
    
    func test_submitNewTask_validTitle_callsInteractorAndOnSuccesDismissesAndReloads() {
        let newItem = makeTodoItem(id: 99, title: "New")
        let exp = expectation(description: "submit then reload")
        
        sut.submitNewTask(title: "  New  ", taskDescription: "desc")
        XCTAssertEqual(interactor.addCallCount, 1)
        XCTAssertEqual(interactor.lastAddTitle, "New")
        XCTAssertEqual(interactor.lastAddTaskDescription, "desc")
        
        
        interactor.addCompletion?(.success(newItem))
        DispatchQueue.main.async {
            self.interactor.loadTodosCompletion?(.success([self.makeTodoItem()]))
        }
        DispatchQueue.main.async { exp.fulfill()}
        wait(for: [exp], timeout: 1.0)
        
        XCTAssertEqual(router.dismissCallCount, 1)
        XCTAssertEqual(interactor.loadTodosCallCount, 1)
        
    }
    
    
    func test_deleteTapped_success_reloadsTodos() {
        let item = makeTodoItem(id: 5)
        let exp = expectation(description: "delete then reload")
        
        
        sut.deleteTapped(item)
        interactor.deleteCompletion?(.success(()))
        DispatchQueue.main.async {
            self.interactor.loadTodosCompletion?(.success([]))
        }
        DispatchQueue.main.async { exp.fulfill() }
        wait(for: [exp], timeout: 1.0)
        
        XCTAssertEqual(interactor.deleteCallCount, 1)
        XCTAssertEqual(interactor.lastDeleteId, 5)
        XCTAssertEqual(interactor.loadTodosCallCount, 1)
        XCTAssertEqual(sut.items.count, 0)
    }
    
    
    func test_addTapped_callsRouterShowAddTask() {
        sut.addTapped()
        XCTAssertEqual(router.showAddTaskCallCount, 1)
    }
    
    func test_editTapped_callsRouterShowEditTask() {
        let item = makeTodoItem(id: 3, title: "Edit me")
        sut.editTapped(item: item)
        XCTAssertEqual(router.showEditTaskCallCount, 1)
        XCTAssertEqual(router.lastEditItem?.id, 3)
        XCTAssertEqual(router.lastEditItem?.title, "Edit me")
        
    }
    
    func test_clearError_clearsErrorMessage() {
        sut.loadTodos()
        interactor.loadTodosCompletion?(.failure(NSError(domain: "t", code: 0, userInfo: [NSLocalizedDescriptionKey: "Error"])))
        
        let exp = expectation(description: "error set")
        DispatchQueue.main.async {exp.fulfill()}
        wait(for: [exp], timeout: 0.5)
        XCTAssertNotNil(sut.errorMessage)
        
        sut.clearError()
        XCTAssertNil(sut.errorMessage)
    }
}

extension TodoListPresenterTests {
    func makeTodoItem(id: Int32 = 1, title: String = "Task", completed: Bool = false) -> TodoItem {
        TodoItem(
            id: id,
            title: title,
            taskDescription: nil,
            createdAt: Date(),
            completed: completed
        )
    }
}
