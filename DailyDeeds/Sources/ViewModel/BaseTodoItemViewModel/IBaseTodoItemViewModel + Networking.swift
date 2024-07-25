//
//  IBaseTodoItemViewModel + Networking.swift
//  DailyDeeds
//
//  Created by Дмитрий Корчагин on 7/25/24.
//

import Foundation

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
