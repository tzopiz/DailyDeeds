//
//  IBaseTodoItemViewModel.swift
//  DailyDeeds
//
//  Created by Дмитрий Корчагин on 7/4/24.
//

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
