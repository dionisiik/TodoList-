import Foundation

struct DummyTodoModel: Decodable, Sendable {
    let id: Int
    let todo: String
    let completed: Bool
    let userId: Int
}

struct DummyTodoResponse: Decodable, Sendable {
    let todos: [DummyTodoModel]
    let total: Int
    let skip: Int
    let limit: Int
}
