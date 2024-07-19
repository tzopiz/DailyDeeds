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
    
    @MainActor func fetchTodoList()
    @MainActor func createTodoItem(with id: String, item: TodoItem)
    @MainActor func updateTodoItem(_ item: TodoItem)
    @MainActor func deleteTodoItem(with id: String)
    @MainActor func complete(_: TodoItem, isDone: Bool)
    @MainActor func toggleCompletion(_: TodoItem)
    
    func save(to fileName: String, format type: FileFormat)
    func loadItems(from fileName: String, format type: FileFormat)
}

// MARK: - Networking
extension IBaseTodoItemViewModel {
    @MainActor
    func fetchTodoList() {
        model.fetchTodoList()
    }
    
    @MainActor
    func createTodoItem(with id: String, item: TodoItem) {
        guard !item.text.isEmpty else { return }
        model.createTodoItem(with: id, item: item)
    }
    
    @MainActor
    func deleteTodoItem(with id: String) {
        model.deleteTodoItem(with: id)
    }
    
    @MainActor
    func updateTodoItem(_ item: TodoItem) {
        if model.containsItem(with: item.id) {
            model.updateTodoItem(with: item.id, item: item)
        } else {
            model.createTodoItem(with: item.id, item: item)
        }
    }
    
    @MainActor
    func complete(_ item: TodoItem, isDone: Bool) {
        let newItem = MutableTodoItem(from: item)
        newItem.isDone = isDone
        updateTodoItem(newItem.immutable)
    }
    
    @MainActor 
    func toggleCompletion(_ item: TodoItem) {
        let newItem = MutableTodoItem(from: item)
        newItem.isDone.toggle()
        updateTodoItem(newItem.immutable)
    }
}

// MARK: - FileCache
extension IBaseTodoItemViewModel {
    func save(to fileName: String, format type: FileFormat = .json) {
        model.save(to: fileName, format: type)
    }

    func loadItems(from fileName: String, format type: FileFormat = .json) {
        model.loadItems(from: fileName, format: type)
    }
}
