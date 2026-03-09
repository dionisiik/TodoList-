
import XCTest
@testable import TodoList

final class TodoListRouterTests: XCTestCase {
    private var sut: TodoListRouter!
    
    override func setUp() {
        super.setUp()
        sut = TodoListRouter()
    }
    
    override func tearDown() {
        sut = nil
        super.tearDown()
    }
    
    func test_showAddTask_setsPresentedRouteToAdd() {
        sut.showAddTask()
        
        guard case .add = sut.presentedRoute else {
            return XCTFail("Expected .add, got \(String(describing: sut.presentedRoute))")
        }
        XCTAssertEqual(sut.presentedRoute?.id, "add")
    }
    
    func test_showViewTask_setsPresentedRouteToView() {
        let item = TodoItem(id: 10, title: "Title", taskDescription: "Desc",
                            createdAt: Date(timeIntervalSince1970: 0), completed: false)
        
        sut.showViewTask(item)
        
        guard case .view(let routedItem) = sut.presentedRoute else {
            return XCTFail("Expected .view")
        }
        XCTAssertEqual(routedItem.id, 10)
        XCTAssertEqual(sut.presentedRoute?.id, "view-10")
    }
    
    func test_showEditTask_setsPresentedRouteToEdit() {
        let item = TodoItem(id: 7, title: "Edit", taskDescription: nil,
                            createdAt: Date(), completed: true)
        
        sut.showEditTask(item)
        
        guard case .edit(let routedItem) = sut.presentedRoute else {
            return XCTFail("Expected .edit")
        }
        XCTAssertEqual(routedItem.id, 7)
        XCTAssertEqual(sut.presentedRoute?.id, "edit-7")
    }
    
    func test_dismiss_setsPresentedRouteToNil() {
        sut.showAddTask()
        XCTAssertNotNil(sut.presentedRoute)
        
        sut.dismiss()
        
        XCTAssertNil(sut.presentedRoute)
    }
}
