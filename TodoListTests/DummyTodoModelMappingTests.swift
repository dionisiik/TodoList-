import XCTest
@testable import TodoList

final class DummyTodoModelMappingTests: XCTestCase {
    
    func test_todoItem_mapsAllFieldsCorrectly() {
        let dto = DummyTodoModel(id: 42, todo: "Buy milk", completed: true, userId: 5)
        let fixedDate = Date(timeIntervalSince1970: 1_000_000)
        
        let result = dto.todoItem(createdAt: fixedDate)
        
        XCTAssertEqual(result.id, 42)
        XCTAssertEqual(result.title, "Buy milk")
        XCTAssertTrue(result.completed)
        XCTAssertEqual(result.createdAt, fixedDate)
        XCTAssertNil(result.taskDescription)
    }
    
    
    func test_todoItem_incompletedTodo_mapsCompletedAsFalse() {
        let dto = DummyTodoModel(id: 1, todo: "Do Homework", completed: false, userId: 3)
        let fixedDate = Date(timeIntervalSince1970: 0)
        
        let result = dto.todoItem(createdAt: fixedDate)
        
        XCTAssertEqual(result.id, 1)
        XCTAssertEqual(result.title, "Do Homework")
        XCTAssertFalse(result.completed)
        XCTAssertEqual(result.createdAt, fixedDate)
        XCTAssertNil(result.taskDescription)
        
    }
}

