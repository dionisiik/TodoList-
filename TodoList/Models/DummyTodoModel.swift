import Foundation

struct DummyTodoModel: Codable, Sendable {
    let id: Int
    let todo: String
    let completed: Bool
    let userId: Int
}

struct DummyTodoResponse: Codable, Sendable {
    let todos: [DummyTodoModel]
    let total: Int
    let skip: Int
    let limit: Int
}
