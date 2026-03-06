//
//  DummyJSONTodoService.swift
//  TodoList
//
//  Created by Дионисий Коневиченко on 06.03.2026.
//

import Foundation

enum DummyJSONTodoServiceError: Error {
    case invalidURL
    case noData
    case decodingError(Error)
    case network(Error)
}

protocol DummyJSONTodoServiceProtocol {
    func fetchTodos(completion: @escaping (Result<[DummyTodoModel],Error>) -> Void)
}


final class DummyJSONTodoService: DummyJSONTodoServiceProtocol {
    private let baseURL = "https://dummyjson.com"
    private let session: URLSession
    
    init(session: URLSession = .shared) {
        self.session = session
    }
    
    func fetchTodos(completion: @escaping (Result<[DummyTodoModel], any Error>) -> Void) {
        guard let url = URL(string:"\(baseURL)/todos") else {
            completion(.failure(DummyJSONTodoServiceError.invalidURL))
            return
        }
        let task = session.dataTask(with: url) { data, response, error in
            if let error = error {
                DispatchQueue.main.async { completion(.failure(DummyJSONTodoServiceError.network(error))) }
                return
            }
            guard let data = data else {
                DispatchQueue.main.async { completion(.failure(DummyJSONTodoServiceError.noData)) }
                return
            }
            DispatchQueue.main.async {
                do {
                    let decoded = try JSONDecoder().decode(DummyTodoResponse.self, from: data)
                    completion(.success(decoded.todos))
                } catch {
                    completion(.failure(DummyJSONTodoServiceError.decodingError(error)))
                }
            }
        }
        task.resume()
    }
}

extension DummyTodoModel {
    /// Маппинг в доменную модель Todo (для списка задач)
    ///  /// Описание в API нет — оставляем nil. Дату ставим дату загрузки.
    func todoItem(createdAt: Date = Date()) -> TodoItem {
        TodoItem(
            id: Int32(id),
            title: todo,
            taskDescription: nil,
            createdAt: createdAt,
            completed: completed
        )
    }
}

