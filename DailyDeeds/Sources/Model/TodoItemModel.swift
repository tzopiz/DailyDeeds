//
//  TodoItemModel.swift
//  DailyDeeds
//
//  Created by Дмитрий Корчагин on 6/15/24.
//

import CocoaLumberjackSwift
import FileCache
import Foundation

final class TodoItemModel: ObservableObject {
    
    @Published
    private(set) var items: [TodoItem]
    @Published
    private(set) var revision: Int = 0
    @Published
    private(set) var isDirty: Bool = false
    
    private let fileCache = FileCache<TodoItem>()
    private let networkingService = DefaultNetworkingService()
    
    init(items: [TodoItem] = []) {
        DDLogInfo("Initializing TodoItemModel with \(items)")
        self.items = items
        self.revision = 0
    }
}

// MARK: - Networking
extension TodoItemModel {
    @MainActor
    func fetchTodoList() {
        handleNetworkTask(#function) {
            try await self.networkingService.fetchTodoList()
        } onSuccess: { response in
            self.updateList(response.result)
        }
    }
    
    @MainActor
    func fetchTodoItem(with id: String) {
        handleNetworkTask(#function) {
            try await self.networkingService.fetchTodoItem(id: id)
        } onSuccess: { response in
            self.updateItem(with: id, item: response.result)
        }
        
    }
    
    @MainActor
    func updateTodoItem(with id: String, item: TodoItem) {
        handleNetworkTask(#function) {
            try await self.networkingService.updateTodoItem(id: id, data: item, revision: self.revision)
        } onSuccess: { response in
            self.updateItem(with: id, item: item)
        }
    }
    
    @MainActor
    func updateTodoList() {
        handleNetworkTask(#function) {
            try await self.networkingService.updateTodoList(patchData: self.items, revision: self.revision)
        } onSuccess: { response in
            self.updateList(response.result)
        }
    }
    
    @MainActor
    func createTodoItem(with id: String, item: TodoItem) {
        handleNetworkTask(#function) {
            try await self.networkingService.createTodoItem(data: item, revision: self.revision)
        } onSuccess: { response in
            self.updateItem(with: id, item: response.result)
        }
    }
    
    @MainActor
    func deleteTodoItem(with id: String, revision: Int) {
        handleNetworkTask(#function) {
            try await self.networkingService.deleteTodoItem(id: id, revision: revision)
        } onSuccess: { response in
            if let item = response.result {
                self.remove(with: id)
                DDLogInfo("TodoItem has been deleted:\n\(item.description)")
            }
        }
    }
    
    // TODO: - retry -
    @MainActor
    private func handleNetworkTask<T: ITodoResponse & Sendable>(
        _ title: String = "",
        task: @escaping () async throws -> T,
        onSuccess: @escaping (T) async -> Void
    ) {
        Task {
            do {
                let response = try await task()
                self.revision = response.revision
                await onSuccess(response)
                
                DDLogVerbose("TodoItemModel.\(title) finished Successfully")
            } catch let error as NetworkingError {
                DDLogError("TodoItemModel.\(title) failed with \(error.description)")
            } catch {
                DDLogError("TodoItemModel.\(title) failed with unhandled error: \(error)")
            }
        }
    }
}

extension TodoItemModel {
    func append(_ item: TodoItem) {
        if !items.contains(where: { $0.id == item.id }) {
            items.append(item)
            DDLogInfo("Appended new item with id \(item.id)")
        } else {
            DDLogInfo("Item with id \(item.id) already exists")
        }
    }
    
    func update(_ item: TodoItem) {
        if let index = items.firstIndex(where: { $0.id == item.id }) {
            items[index] = item
            DDLogInfo("Updated item with id \(item.id)")
        } else {
            items.append(item)
            DDLogInfo("Appended new item with id \(item.id) during update")
        }
    }
    
    func updateItem(with id: String, item: TodoItem?) {
        if let index = items.firstIndex(where: { $0.id == id }), let item = item {
            items[index] = item
            DDLogInfo("Updated item with id \(item.id)")
        } else if let item = item {
            items.append(item)
            DDLogInfo("Appended new item with id \(item.id) during update")
        } else {
            DDLogVerbose("The item with the id \(id) is up to date in the list")
        }
    }
    
    func updateList(_ todoItems: [TodoItem]) {
        self.items = todoItems
    }
    
    func move(fromOffsets indices: IndexSet, toOffset newOffset: Int) {
        items.move(fromOffsets: indices, toOffset: newOffset)
        DDLogInfo("Moved items from offsets \(indices) to new offset \(newOffset)")
    }
    
    func remove(with id: String) {
        items.removeAll { $0.id == id }
        DDLogInfo("Removed item with id \(id)")
    }
    
    func remove(at offsets: IndexSet) {
        items.remove(atOffsets: offsets)
        DDLogInfo("Removed items at offsets \(offsets)")
    }
    
    func updateAllItems(_ items: [TodoItem]) {
        self.items = items
    }
    
    func containsItem(with id: String) -> Bool {
        return items.contains(where: { $0.id == id })
    }
    
    func makeDirty() {
        self.isDirty = true
    }
}

// MARK: - FileCache
extension TodoItemModel {
    func save(to fileName: String, format type: FileCache<TodoItem>.FileFormat = .json) {
        if let error = fileCache.saveToFile(items, named: fileName, format: type) {
            DDLogError("Failed to save items to file \(fileName): \(error.localizedDescription)")
        } else {
            DDLogInfo("Successfully saved items to file \(fileName)")
        }
    }
    
    func loadItems(from fileName: String, format type: FileCache<TodoItem>.FileFormat = .json) {
        let result = fileCache.loadFromFile(named: fileName, format: type)
        switch result {
        case .success(let items):
            self.items = items
            DDLogInfo("Successfully loaded items from file \(fileName)")
        case .failure(let error):
            DDLogError("Failed to load items from file \(fileName): \(error.localizedDescription)")
        }
    }
}
