//
//  IBaseTodoItemViewModel.swift
//  DailyDeeds
//
//  Created by Дмитрий Корчагин on 7/4/24.
//

import Foundation
import FileCache

protocol IBaseTodoItemViewModel {
    var model: TodoItemModel { get set }
    func removeAll()
    func remove(with id: String)
    func append(_: TodoItem)
    func update(oldItem: TodoItem, to: TodoItem?)
    func complete(_: TodoItem, isDone: Bool)
    func toggleCompletion(_: TodoItem)
    func addTodoItems(_: [TodoItem])
    func save(to fileName: String, format type: FileCache<TodoItem>.FileFormat)
    func loadItems(from fileName: String, format type: FileCache<TodoItem>.FileFormat)
}

extension IBaseTodoItemViewModel {

    // MARK: - Remove
    func remove(with id: String) {
        model.remove(with: id)
    }

    func removeAll() {
        for item in model.items {
            model.remove(with: item.id)
        }
    }

    // MARK: - Create
    func addTodoItems(_ items: [TodoItem]) {
        items.forEach { model.append($0) }
    }

    func append(_ item: TodoItem) {
        if item.text.count > 0 {
            model.append(item)
        }
    }

    // MARK: - Update
    func update(oldItem: TodoItem, to newItem: TodoItem?) {
        guard let newItem = newItem else {
            model.remove(with: oldItem.id)
            return
        }
        if newItem.id == oldItem.id, newItem.text.count > 0 {
            model.update(newItem)
        }
    }

    func complete(_ item: TodoItem, isDone: Bool) {
        let newItem = MutableTodoItem(from: item)
        newItem.isDone = isDone
        update(oldItem: item, to: newItem.immutable)
    }

    func toggleCompletion(_ item: TodoItem) {
        let newItem = MutableTodoItem(from: item)
        newItem.isDone.toggle()
        update(oldItem: item, to: newItem.immutable)
    }

    // MARK: - FileCache
    func save(to fileName: String, format type: FileCache<TodoItem>.FileFormat = .json) {
        model.save(to: fileName, format: type)
    }

    func loadItems(from fileName: String, format type: FileCache<TodoItem>.FileFormat = .json) {
        model.loadItems(from: fileName, format: type)
    }
}
