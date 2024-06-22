//
//  SwiftUIView.swift
//  DailyDeeds
//
//  Created by Дмитрий Корчагин on 6/22/24.
//

import SwiftUI

class TodoListViewModel: ObservableObject {
    @Published 
    var fileCache = FileCache()
    init() {
        fileCache.addTodoItems(
            TodoItem(
                text: "Купить молоко Купить молоко Купить молоко Купить молоко Купить молоко Купить молоко Купить молоко",
                isDone: true,
                importance: .medium
            ),
            TodoItem(
                text: "Написать отчет",
                isDone: true,
                importance: .high,
                deadline: Date().addingTimeInterval(86400)
            ),
            TodoItem(
                text: "Позвонить бабушкеПозвонить бабушкеПозвонить бабушкеПозвонить бабушкеПозвонить бабушкеПозвонить бабушкеПозвонить бабушкеПозвонить бабушкеПозвонить бабушке",
                isDone: true,
                importance: .low
            ),
            TodoItem(
                text: "Купить молоко",
                isDone: false,
                importance: .medium
            ),
            TodoItem(
                text: "Написать отчет",
                isDone: false,
                importance: .high,
                deadline: Date().addingTimeInterval(86400)
            ),
            TodoItem(
                text: "Позвонить бабушке",
                isDone: false,
                importance: .low
            )
        )
    }
    
    func addItem(_ item: TodoItem) {
        fileCache.addTodoItem(item)
    }
    
    func removeItem(at offsets: IndexSet) {
        fileCache.removeTodoItem(at: offsets)
    }
    
    func move(fromOffsets indices: IndexSet, toOffset newOffset: Int) {
        fileCache.move(fromOffsets: indices, toOffset: newOffset)
    }
}
