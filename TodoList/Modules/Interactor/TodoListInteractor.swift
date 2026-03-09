import Foundation

private let hasLoadedFromAPIKey = "TodoList.hasLoadedFromAPI"


final class TodoListInteractor: TodoListInteractorProtocol {
    
    private let repository: TodoRepositoryProtocol
    private let apiService: DummyJSONTodoServiceProtocol
    private let queue = DispatchQueue(label: "com.todolist.interactor", qos: .userInitiated)
    
    init(repository: TodoRepositoryProtocol, apiService: DummyJSONTodoServiceProtocol) {
        self.repository = repository
        self.apiService = apiService
    }
    
    func loadTodos(completion: @escaping (Result<[TodoItem], Error>) -> Void) {
        queue.async { [weak self] in
            guard let self else { return }
            let hasLoaded = UserDefaults.standard.bool(forKey: hasLoadedFromAPIKey)
            if !hasLoaded {
                self.apiService.fetchTodos { [weak self] result in
                    guard let self else { return }
                    switch result {
                    case .success(let dtos):
                        let items = dtos.map { $0.todoItem(createdAt: Date()) }
                        self.saveTodoItemsFromAPI(items) { saveResult in
                            switch saveResult {
                            case .success:
                                UserDefaults.standard.set(true, forKey: hasLoadedFromAPIKey)
                                self.repository.fetchAll { fetchResult in
                                    DispatchQueue.main.async { completion(fetchResult) }
                                }
                            case .failure(let error):
                                DispatchQueue.main.async { completion(.failure(error)) }
                            }
                        }
                    case .failure(let error):
                        DispatchQueue.main.async { completion(.failure(error)) }
                    }
                }
            } else {
                self.repository.fetchAll { result in
                    DispatchQueue.main.async { completion(result) }
                }
            }
        }
    }
    
    func add(title: String, taskDescription: String?, completed: Bool, completion: @escaping (Result<TodoItem,Error>) -> Void) {
        queue.async { [weak self] in
            self?.repository.add(title: title, taskDescription: taskDescription, completed: completed) { result in
                DispatchQueue.main.async { completion(result) }
            }
        }
    }
    
    func update(_ item: TodoItem, completion: @escaping (Result<Void, Error>) -> Void) {
        queue.async { [weak self] in
            self?.repository.update(item) { result in
                DispatchQueue.main.async { completion(result) }
            }
        }
    }
    
    func delete(id: Int32, completion: @escaping (Result<Void, Error>) -> Void) {
        queue.async { [weak self] in
            self?.repository.delete(id: id) { result in
                DispatchQueue.main.async { completion(result) }
            }
        }
    }
    func search(query: String, completion: @escaping (Result<[TodoItem], any Error>) -> Void) {
        queue.async { [weak self] in
            self?.repository.search(query: query) { result in
                DispatchQueue.main.async { completion(result) }
            }
        }
    }
    
    
    private func saveTodoItemsFromAPI(_ items: [TodoItem], completion: @escaping (Result<Void, Error>) -> Void) {
        var lastError: Error?
        let group = DispatchGroup()
        for item in items {
            group.enter()
            repository.add(title: item.title, taskDescription: item.taskDescription, completed: item.completed) { result in
                if case .failure(let e) = result { lastError = e }
                group.leave()
            }
        }
        group.notify(queue: queue) {
            if let lastError {
                DispatchQueue.main.async { completion(.failure(lastError)) }
            } else {
                DispatchQueue.main.async { completion(.success(())) }
            }
        }
    }
}



