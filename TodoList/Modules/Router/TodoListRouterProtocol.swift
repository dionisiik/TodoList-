//
//  TodoListRouterProtocol.swift
//  TodoList
//
//  Created by Дионисий Коневиченко on 06.03.2026.
//


import Foundation

protocol TodoListRouterProtocol: AnyObject {
    
    // Экран добавления новой задачи
    func showAddTask()
    // Экран редактирования задачи
    func showEditTask(_ item: TodoItem)
    // Закрытие задачи
    func dismiss()
}
