//
//  MutableTodoItem.swift
//  DailyDeeds
//
//  Created by Дмитрий Корчагин on 6/26/24.
//

import Foundation


struct MutableTodoItem {
    private let id: String
    var text: String
    var isDone: Bool
    var importance: Importance
    var hexColor: String
    private let creationDate: Date
    var deadline: Date?
    var modificationDate: Date?
    
    init(from item: TodoItem) {
        self.id = item.id
        self.text = item.text
        self.isDone = item.isDone
        self.importance = item.importance
        self.hexColor = item.hexColor
        self.creationDate = item.creationDate
        self.deadline = item.deadline
        self.modificationDate = item.modificationDate
    }
    
    var immutable: TodoItem {
        TodoItem(
            id: self.id,
            text: self.text,
            isDone: self.isDone,
            importance: self.importance,
            hexColor: self.hexColor,
            creationDate: self.creationDate,
            deadline: self.deadline,
            modificationDate: self.modificationDate
        )
    }
}
