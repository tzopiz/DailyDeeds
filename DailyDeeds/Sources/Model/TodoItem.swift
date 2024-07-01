//
//  TodoItem.swift
//  DailyDeeds
//
//  Created by Дмитрий Корчагин on 6/14/24.
//

import Foundation

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
    }
    
    let id: String
    let text: String
    let isDone: Bool
    let importance: Importance
    let hexColor: String
    let creationDate: Date
    let deadline: Date?
    let modificationDate: Date?
    
    /// Initializes a new instance of the TodoItem task.
    /// - Parameters:
    ///   - id: The unique identifier of the task. By default, a new UUID is generated.
    ///   - text: Description of the task.
    ///   - importance: The level of importance of the task (low, medium, high).
    ///   - isDone: A flag indicating whether the task has been completed. By default, false.
    ///   - creationDate: The date the task was created. By default, the current date and time.
    ///   - deadline: The deadline for the task. By default, nil.
    ///   - modificationDate: The date the issue was last modified. By default, nil.
    init(
        id: String = UUID().uuidString,
        text: String,
        isDone: Bool = false,
        importance: Importance = .medium,
        hexColor: String = "#FFFFFF",
        creationDate: Date = .now,
        deadline: Date? = nil,
        modificationDate: Date? = nil
    ) {
        self.id = id
        self.text = text
        self.isDone = isDone
        self.importance = importance
        self.hexColor = hexColor
        self.creationDate = creationDate
        self.deadline = deadline
        self.modificationDate = modificationDate
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
        \t\(CodingKeys.modificationDate): \(modificationDate != nil ? modificationDate.toString() : "nil")
        )
        """
    }
}
