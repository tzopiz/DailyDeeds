//
//  TodoItemModel.swift
//  DailyDeeds
//
//  Created by Дмитрий Корчагин on 6/15/24.
//

import Foundation
import FileCache

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
    private(set) var items: Array<TodoItem>
    
    private let fileCache = FileCache<TodoItem>()
    init(items: Array<TodoItem>) {
        self.items = items
    }
}

extension TodoItemModel {
    func save(to fileName: String, format type: FileCache<TodoItem>.FileFormat = .json) {
        if let error = fileCache.saveToFile(items, named: fileName, format: type) {
            print(error.localizedDescription)
        }
    }
    
    // MARK: - Read
    func loadItems(from fileName: String, format type: FileCache<TodoItem>.FileFormat = .json) {
        let result = fileCache.loadFromFile(named: fileName, format: type)
        switch result {
        case .success(let items):
            self.items = items
        case .failure(let error):
            print(error.localizedDescription)
        }
    }
}

extension TodoItemModel {
    func append(_ item: TodoItem) {
        if !items.contains(where: { $0.id == item.id }) {
            items.append(item)
        }
    }
    
    func update(_ item: TodoItem) {
        if let index = items.firstIndex(where: { $0.id == item.id }) {
            items[index] = item
        } else {
            items.append(item)
        }
    }
    
    func move(fromOffsets indices: IndexSet, toOffset newOffset: Int) {
        items.move(fromOffsets: indices, toOffset: newOffset)
    }
    
    func remove(with id: String) {
        items.removeAll { $0.id == id }
    }
    
    func remove(at offsets: IndexSet) {
        items.remove(atOffsets: offsets)
    }
}
