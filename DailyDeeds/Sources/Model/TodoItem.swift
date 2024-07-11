//
//  TodoItem.swift
//  DailyDeeds
//
//  Created by Дмитрий Корчагин on 6/14/24.
//

import Foundation
import FileCache

enum Importance: String, Comparable, Equatable {
    case low = "неважная"
    case medium = "обычная"
    case high = "важная"

    var order: Int {
        switch self {
        case .low: return 0
        case .medium: return 1
        case .high: return 2
        }
    }

    static func < (lhs: Importance, rhs: Importance) -> Bool {
        return lhs.order < rhs.order
    }
}

struct TodoItem: Identifiable, Equatable, Hashable, KeyPathComparable {
    enum CodingKeys {
        static let id = "id"
        static let text = "text"
        static let isDone = "isDone"
        static let importance = "importance"
        static let hexColor = "hexColor"
        static let creationDate = "creationDate"
        static let deadline = "deadline"
        static let modificationDate = "modificationDate"
        static let category = "category"
    }

    let id: String
    let text: String
    let isDone: Bool
    let importance: Importance
    let hexColor: String
    let creationDate: Date
    let deadline: Date?
    let modificationDate: Date?
    let category: Category

    init(
        id: String = UUID().uuidString,
        text: String,
        isDone: Bool = false,
        importance: Importance = .medium,
        hexColor: String = "#FFFFFF",
        creationDate: Date = .now,
        deadline: Date? = nil,
        modificationDate: Date? = nil,
        category: Category = Category.defaultCategory
    ) {
        self.id = id
        self.text = text
        self.isDone = isDone
        self.importance = importance
        self.hexColor = hexColor
        self.creationDate = creationDate
        self.deadline = deadline
        self.modificationDate = modificationDate
        self.category = category
    }

    var mutable: MutableTodoItem {
        return MutableTodoItem(from: self)
    }
}

// MARK: - CustomStringConvertible
extension TodoItem: CustomStringConvertible {
    var description: String {
        return """
        TodoItem(
        \t\(CodingKeys.id): \(id),
        \t\(CodingKeys.text): \"\(text)\",
        \t\(CodingKeys.isDone): \(isDone),
        \t\(CodingKeys.importance): \(importance.rawValue),
        \t\(CodingKeys.hexColor): \(hexColor),
        \t\(CodingKeys.creationDate): \(creationDate.toString()),
        \t\(CodingKeys.deadline): \(deadline != nil ? deadline.toString() : "nil"),
        \t\(CodingKeys.modificationDate): \(modificationDate != nil ? modificationDate.toString() : "nil"),
        \t\(CodingKeys.category): \(category.name) \(category.color ?? "")
        )
        """
    }
}
