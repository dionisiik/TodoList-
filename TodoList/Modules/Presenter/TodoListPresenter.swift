//
//  TodoListPresenter.swift
//  TodoList
//
//  Created by Дионисий Коневиченко on 06.03.2026.
//

import Foundation
import Combine

final class TodoListPresenter: ObservableObject {
    @Published private(set) var items: [TodoItem] = []
    @Published private(set) var errorMessage: String?
    @Published private(set) var isLoading = false
    
    
    private let interactor: TodoListInteractorProtocol
    private weak var router: TodoListRouterProtocol?
    
    init(interactor: TodoListInteractorProtocol, router: TodoListRouterProtocol) {
        self.interactor = interactor
        self.router = router
    }
    
    func onAppear() {
        loadTodos()
    }
    
    func loadTodos() {
        isLoading = true
        errorMessage = nil
        interactor.loadTodos { [weak self] result in
            guard let self else { return }
            self.isLoading = false
            switch result {
            case .success(let list):
                self.items = list
            case .failure(let error):
                self.errorMessage = error.localizedDescription
            }
        }
    }
    
    func submitNewTask(title: String, taskDescription: String?) {
        guard !title.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {return}
        interactor.add(title: title.trimmingCharacters(in: .whitespacesAndNewlines), taskDescription: taskDescription?.isEmpty == true ? nil : taskDescription?.trimmingCharacters(in: .whitespacesAndNewlines), completed: false) { [weak self] result in
            guard let self else {return}
            switch result {
            case .success:
                self.router?.dismiss()
                self.loadTodos()
            case .failure(let error):
                self.errorMessage = error.localizedDescription
            }
        }
    }
    
    func submitUpdatedTask(_ updated: TodoItem) {
        interactor.update(updated) { [weak self] result in
            guard let self else {return}
            switch result {
            case .success:
                self.router?.dismiss()
                self.loadTodos()
            case .failure(let error):
                self.errorMessage = error.localizedDescription
            }
        }
    }
    
    func addTapped() {
        router?.showAddTask()
    }

    func viewTapped(item: TodoItem) {
        router?.showViewTask(item)
    }

    func editTapped(item: TodoItem) {
        router?.showEditTask(item)
    }
    
    
    func deleteTapped(_ item: TodoItem) {
        interactor.delete(id: item.id) { [weak self] result in
            guard let self else { return }
            switch result {
            case .success:
                self.loadTodos()
            case .failure(let error):
                self.errorMessage = error.localizedDescription
            }
        }
    }
    
    func searchChanged(_ query: String) {
        interactor.search(query: query) { [weak self] result in
            guard let self else { return }
            switch result {
            case .success(let list):
                self.items = list
            case .failure(let error):
                self.errorMessage = error.localizedDescription
            }
        }
    }
    
    func toggleCompleted(_ item: TodoItem) {
        var updated = item
        updated.completed.toggle()
        interactor.update(updated) { [weak self] result in
            guard let self else {return}
            switch result {
            case .success:
                self.loadTodos()
            case .failure(let error):
                self.errorMessage = error.localizedDescription
            }
        }
    }
    
    func clearError() {
        errorMessage = nil
    }
}
