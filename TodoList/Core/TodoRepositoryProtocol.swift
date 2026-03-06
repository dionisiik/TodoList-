//
//  TodoRepositoryProtocol.swift
//  TodoList
//
//  Created by Дионисий Коневиченко on 06.03.2026.
//

import Foundation

struct TodoItem {
    let id: Int32
    var title: String
    var taskDescription: String?
    var createdAt: Date
    var completed: Bool
}


protocol TodoRepositoryProtocol: AnyObject {
    
    // Загрузка задачи
    func fetchAll(completion: @escaping (Result<[TodoItem], Error>) -> Void)
    
    // Добавление задачи
    func add(title: String, taskDescription: String?, completed: Bool,  completion: @escaping (Result<TodoItem, Error>) -> Void)
    
    // Обновить существующую задачу по id
    func update(_ item: TodoItem, completion: @escaping (Result<Void, Error>) -> Void)
    
    //Удалить задачу по id
    func delete(id: Int32, completion: @escaping (Result<Void, Error>) -> Void)
    
    // Поиск по названию/описанию
    func search(query:String, completion: @escaping (Result<[TodoItem], Error>) -> Void)
}
