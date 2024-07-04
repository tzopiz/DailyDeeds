//
//  IBaseTodoItemViewModel.swift
//  DailyDeeds
//
//  Created by Дмитрий Корчагин on 7/4/24.
//

import Foundation

protocol IBaseTodoItemViewModel {
    var model: TodoItemModel { get set }
    func removeAll()
    func remove(with id: String)
    func append(_: TodoItem)
    func update(oldItem: TodoItem, to: TodoItem?)
    func complete(_: TodoItem, isDone: Bool)
    func toggleCompletion(_: TodoItem)
    func addTodoItems(_: Array<TodoItem>)
    func save(to: String, format: TodoItemModel.FileFormat)
    func loadItems(from: String, format: TodoItemModel.FileFormat)
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
    func addTodoItems(_ items: Array<TodoItem>) {
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
    
    // MARK: - Save
    func save(to fileName: String, format type: TodoItemModel.FileFormat = .json) {
        if let error = model.saveToFile(named: fileName, format: type) {
            print(error.localizedDescription)
        }
    }
    
    // MARK: - Read
    func loadItems(from fileName: String, format type: TodoItemModel.FileFormat = .json) {
        let result = model.loadFromFile(named: fileName, format: type)
        switch result {
        case .success(let items):
            removeAll()
            addTodoItems(items)
        case .failure(let error):
            print(error.localizedDescription)
        }
    }
}
