//
//  TodoListInteractorProtocol.swift
//  TodoList
//
//  Created by Дионисий Коневиченко on 06.03.2026.
//

import Foundation


protocol TodoListInteractorProtocol: AnyObject {
    
    func loadTodos(completion: @escaping (Result<[TodoItem], Error>) -> Void)
    func add(title: String, taskDescription: String?, completed: Bool, completion: @escaping (Result<TodoItem, Error>) -> Void)
    func update(_ item: TodoItem, completion: @escaping (Result<Void, Error>) -> Void)
    func delete(id: Int32, completion: @escaping (Result<Void, Error>) -> Void)
    func search(query: String, completion: @escaping (Result<[TodoItem], Error>) -> Void)
    
}
