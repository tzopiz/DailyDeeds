//
//  IBaseTodoItemViewModel.swift
//  DailyDeeds
//
//  Created by Дмитрий Корчагин on 7/4/24.
//

import CocoaLumberjackSwift
import FileCache
import Foundation

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
        DDLogInfo("Removing item with id \(id)")
    }

    func removeAll() {
        for item in model.items {
            model.remove(with: item.id)
        }
        DDLogInfo("Removing all items")
    }

    // MARK: - Create
    func addTodoItems(_ items: [TodoItem]) {
        items.forEach { model.append($0) }
        DDLogInfo("Adding multiple items: \(items.count) items")
    }

    func append(_ item: TodoItem) {
        if item.text.count > 0 {
            model.append(item)
            DDLogInfo("Appending item with id \(item.id)")
        } else {
            DDLogInfo("Skipping append due to empty text for item with id \(item.id)")
        }
    }

    // MARK: - Update
    func update(oldItem: TodoItem, to newItem: TodoItem?) {
        guard let newItem = newItem else {
            model.remove(with: oldItem.id)
            DDLogInfo("Removing item with id \(oldItem.id) as newItem is nil")
            return
        }
        if newItem.id == oldItem.id, newItem.text.count > 0 {
            model.update(newItem)
            DDLogInfo("Updating item with id \(oldItem.id)")
        } else {
            DDLogInfo("Skipping update due to id mismatch or empty text for item with id \(oldItem.id)")
        }
    }

    func complete(_ item: TodoItem, isDone: Bool) {
        let newItem = MutableTodoItem(from: item)
        newItem.isDone = isDone
        update(oldItem: item, to: newItem.immutable)
        DDLogInfo("Marking item with id \(item.id) as \(isDone ? "complete" : "incomplete")")
    }

    func toggleCompletion(_ item: TodoItem) {
        let newItem = MutableTodoItem(from: item)
        newItem.isDone.toggle()
        update(oldItem: item, to: newItem.immutable)
        DDLogInfo("Toggling completion for item with id \(item.id)")
    }

    // MARK: - FileCache
    func save(to fileName: String, format type: FileCache<TodoItem>.FileFormat = .json) {
        model.save(to: fileName, format: type)
        DDLogInfo("Saving items to file \(fileName) with format \(type)")
    }

    func loadItems(from fileName: String, format type: FileCache<TodoItem>.FileFormat = .json) {
        model.loadItems(from: fileName, format: type)
        DDLogInfo("Loading items from file \(fileName) with format \(type)")
    }
}
