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
    private(set) var isDirty: Bool = false
    @Published
    var isLoading: Bool = false
    
    let networkingService = DefaultNetworkingService()
    var monitorTask: Task<Void, Never>?
    private(set) var revision: Int = 0

    @MainActor
    init(items: [TodoItem] = []) {
        DDLogInfo("Initializing TodoItemModel with \(items)")
        self.items = items
        self.revision = 0
        Task {
            await startMonitoringNetworkActivity()
        }
    }
    
    deinit {
        stopMonitoringNetworkActivity()
    }
}

// MARK: - Interaction
extension TodoItemModel {
    func append(_ item: TodoItem?) {
        guard let item else {
            DDLogError("Error trying to add an object to the none list")
            return
        }
        if let index = items.firstIndex(where: { $0.id == item.id }) {
            DDLogError("The item with the \(item.id) id already exists in the list on \(index) index")
        } else {
            items.append(item)
            DDLogInfo("Appended new item with id \(item.id)")
        }
    }
    
    func updateItem(with id: String, item: TodoItem?) {
        guard let item else {
            DDLogError("Error trying to add an object to the none list")
            return
        }
        if let index = items.firstIndex(where: { $0.id == id }) {
            items[index] = item
            DDLogInfo("Updated item with id \(item.id)")
        } else {
            DDLogError("The item with the id \(id) already exists in the list")
        }
    }
    
    func updateList(_ todoItems: [TodoItem]) {
        self.items = todoItems
        DDLogInfo("TodoItems list updated")
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
    
    func containsItem(with id: String) -> Bool {
        return items.contains(where: { $0.id == id })
    }
    
    func updateRevision(to value: Int) {
        self.revision = value
    }
    
    func makeDirty(_ value: Bool) {
        self.isDirty = value
    }
}
