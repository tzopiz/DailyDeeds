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

struct TodoItem: Identifiable, Equatable, KeyPathComparable {
    enum CodingKeys: String, CodingKey {
        case id, text, isDone, importance, hexColor
        case creationDate, deadline, modificationDate
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
        isDone: Bool,
        importance: Importance,
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
}

// MARK: - CustomStringConvertible
extension TodoItem: CustomStringConvertible {
    var description: String {
        return """
        TodoItem(
        \t\(CodingKeys.id.stringValue): \(id),
        \t\(CodingKeys.text.stringValue): \"\(text)\",
        \t\(CodingKeys.isDone.stringValue): \(isDone),
        \t\(CodingKeys.importance.stringValue): \(importance.rawValue),
        \t\(CodingKeys.hexColor.stringValue): \(hexColor),
        \t\(CodingKeys.creationDate.stringValue): \(creationDate.toString()),
        \t\(CodingKeys.deadline.stringValue): \(deadline != nil ? deadline.toString() : "nil"),
        \t\(CodingKeys.modificationDate.stringValue): \(modificationDate != nil ? modificationDate.toString() : "nil")
        )
        """
    }
}
