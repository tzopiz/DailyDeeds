//
//  TodoItem.swift
//  DailyDeeds
//
//  Created by Дмитрий Корчагин on 6/14/24.
//

import FileCache
import Foundation
import SwiftData

@Model
final class TodoItem: Identifiable, Equatable, Hashable, KeyPathComparable, Sendable {
    enum CodingKeys {
        static let id = "id"
        static let text = "text"
        static let isDone = "done"
        static let hexColor = "color"
        static let category = "category"
        static let importance = "importance"
        static let creationDate = "created_at"
        static let modificationDate = "changed_at"
        static let lastUpdatedDevice = "last_updated_by"
        static let deadline = "deadline"
    }
    
    @Attribute(.unique)
    let id: String
    let text: String
    let isDone: Bool
    let hexColor: String
    let creationDate: Date
    let category: Category
    let importance: Importance
    let modificationDate: Date
    let lastUpdatedDevice: String
    let deadline: Date?
    
    init(
        id: String = UUID().uuidString,
        text: String,
        isDone: Bool = false,
        hexColor: String = "#FFFFFF",
        creationDate: Date = .now,
        category: Category = .default,
        importance: Importance = .medium,
        modificationDate: Date = .now,
        lastUpdatedDevice: String = "default",
        deadline: Date? = nil
    ) {
        self.id = id
        self.text = text
        self.isDone = isDone
        self.hexColor = hexColor
        self.creationDate = creationDate
        self.category = category
        self.importance = importance
        self.modificationDate = modificationDate
        self.lastUpdatedDevice = lastUpdatedDevice
        self.deadline = deadline
    }

    var mutable: MutableTodoItem {
        return MutableTodoItem(from: self)
    }
}

// MARK: - CustomStringConvertible
extension TodoItem: CustomStringConvertible {
    var description: String {
        """
        TodoItem(
        \t\(CodingKeys.id): \(id),
        \t\(CodingKeys.text): \"\(text)\",
        \t\(CodingKeys.isDone): \(isDone),
        \t\(CodingKeys.importance): \(importance.rawValue),
        \t\(CodingKeys.hexColor): \(hexColor),
        \t\(CodingKeys.creationDate): \(creationDate.toString()),
        \t\(CodingKeys.modificationDate): \(modificationDate.toString()),
        \t\(CodingKeys.category): \(category.name) \(category.color ?? ""),
        \t\(CodingKeys.lastUpdatedDevice): \(lastUpdatedDevice),
        \t\(CodingKeys.deadline): \(deadline != nil ? deadline.toString() : "nil")
        )
        """
    }
}
