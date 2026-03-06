//
//  CoreDataTodoRepository.swift
//  TodoList
//
//  Created by Дионисий Коневиченко on 06.03.2026.
//

import CoreData

final class CoreDataTodoRepository: TodoRepositoryProtocol {
    
    
    private let context: NSManagedObjectContext
    
    init(context: NSManagedObjectContext) {
        self.context = context
    }
    
    func fetchAll(completion: @escaping (Result<[TodoItem], any Error>) -> Void) {
        
        context.perform {
            do
            {
                let request = Item.fetchRequest()
                request.sortDescriptors = [NSSortDescriptor(keyPath: \Item.createdAt, ascending: false)]
                let items = try self.context.fetch(request)
                let result = items.compactMap { self.map($0) }
                DispatchQueue.main.async { completion(.success(result)) }
            } catch {
                DispatchQueue.main.async { completion(.failure(error)) }
            }
        }
    }
    func add(title: String, taskDescription: String?, completed: Bool, completion: @escaping (Result<TodoItem, any Error>) -> Void) {
        context.perform {
            do {
                let newItem = Item(context: self.context)
                newItem.id = self.nextAvailableId()
                newItem.title = title
                newItem.taskDescription = taskDescription
                newItem.createdAt = Date()
                newItem.completed = completed
                try self.context.save()
                guard let saved = self.map(newItem) else {
                    DispatchQueue.main.async { completion(.failure(NSError(domain: "TodoRepository", code: -1, userInfo: [NSLocalizedDescriptionKey: "Mapping failed"])))
                    }
                    return
                }
                DispatchQueue.main.async { completion(.success(saved))}
            } catch {
                DispatchQueue.main.async { completion(.failure(error))}
            }
        }
    }
    
    
    func update(_ item: TodoItem, completion: @escaping (Result<Void, any Error>) -> Void) {
        context.perform {
            do {
                let request = Item.fetchRequest()
                request.predicate = NSPredicate(format: "id == %d", item.id)
                request.fetchLimit = 1
                guard let managed = try self.context.fetch(request).first else {
                    DispatchQueue.main.async { completion(.failure(NSError(domain: "TodoRepository", code: 404, userInfo: [NSLocalizedDescriptionKey: "Item not found"]))) }
                    return
                }
                managed.title = item.title
                managed.taskDescription = item.taskDescription
                managed.createdAt = item.createdAt
                managed.completed = item.completed
                try self.context.save()
                DispatchQueue.main.async { completion(.success(())) }
            } catch {
                DispatchQueue.main.async { completion(.failure(error)) }
            }
        }
    }
    
    
    func delete(id: Int32, completion: @escaping (Result<Void, any Error>) -> Void) {
        context.perform {
            do {
                let request = Item.fetchRequest()
                request.predicate = NSPredicate(format: "id == %d", id)
                request.fetchLimit = 1
                guard let managed = try self.context.fetch(request).first else {
                    DispatchQueue.main.async { completion(.failure(NSError(domain: "TodoRepository", code: 404, userInfo: [NSLocalizedDescriptionKey: "Item not found"]))) }
                    return
                }
                self.context.delete(managed)
                try self.context.save()
                DispatchQueue.main.async { completion(.success(())) }
            } catch {
                DispatchQueue.main.async { completion(.failure(error)) }
            }
        }
    }
    
    
    func search(query: String, completion: @escaping (Result<[TodoItem], any Error>) -> Void) {
        context.perform {
            do {
                let request = Item.fetchRequest()
                if query.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                    request.predicate = nil
                } else {
                    let trimmed = query.trimmingCharacters(in: .whitespacesAndNewlines)
                    request.predicate = NSPredicate(
                        format: "title CONTAINS[c] %@ OR taskDescription CONTAINS[c] %@",
                        trimmed, trimmed
                    )
                }
                request.sortDescriptors = [NSSortDescriptor(keyPath: \Item.createdAt, ascending: true)]
                let items = try self.context.fetch(request)
                let result = items.compactMap { self.map($0) }
                DispatchQueue.main.async { completion(.success(result)) }
            } catch {
                DispatchQueue.main.async { completion(.failure(error)) }
            }
        }
        
    }

    
    
    
    
    // Mapping
    
    private func map(_ item: Item) -> TodoItem? {
        guard let title = item.title, let createdAt = item.createdAt else { return nil }
        return TodoItem(
            id: item.id,
            title: title,
            taskDescription: item.taskDescription,
            createdAt: createdAt,
            completed: item.completed
        )
    }
    
    private func nextAvailableId() -> Int32 {
        let request = Item.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(keyPath: \Item.id, ascending: false)]
        request.fetchLimit = 1
        return (try? context.fetch(request).first?.id).map { $0 + 1 } ?? 1
    }
    
}

