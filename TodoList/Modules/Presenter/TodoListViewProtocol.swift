//
//  TodoListViewProtocol.swift
//  TodoList
//
//  Created by Дионисий Коневиченко on 06.03.2026.
//

import Foundation

protocol TodoListViewProtocol: AnyObject {
    func displayItems(_ items: [TodoItem])
    func displayError(_ message: String)
    func setLoading(_ isLoading: Bool)
}
