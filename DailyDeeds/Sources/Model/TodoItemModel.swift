//
//  TodoItemModel.swift
//  DailyDeeds
//
//  Created by Дмитрий Корчагин on 6/15/24.
//

import Foundation
import FileCache
import CocoaLumberjackSwift

final class TodoItemModel: ObservableObject {
    enum FileFormat {
        case json
        case csv
    }

    enum FileError: Error {
        case fileNotFound
        case dataCorrupted
        case parseFailed
        case writeToFileFailed
        case incorrectFileName
        case directoryNotFound
        case loadFromJSONFileFailed
        case loadFromCSVFileFailed
        case fileAlreadyExists
        case unknown
    }

    @Published
    private(set) var items: [TodoItem]

    private let fileCache = FileCache<TodoItem>()
    init(items: [TodoItem]) {
        DDLogInfo("Initializing TodoItemModel with \(items)")
        self.items = items
    }
}

extension TodoItemModel {
    func save(to fileName: String, format type: FileCache<TodoItem>.FileFormat = .json) {
        if let error = fileCache.saveToFile(items, named: fileName, format: type) {
            DDLogError("Failed to save items to file \(fileName): \(error.localizedDescription)")
        } else {
            DDLogInfo("Successfully saved items to file \(fileName)")
        }
    }

    // MARK: - Read
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
}
