//
//  TodoItem.swift
//  DailyDeeds
//
//  Created by Дмитрий Корчагин on 6/14/24.
//

import Foundation

enum Importance: String, Comparable, Equatable, Codable {
    case low = "неважная"
    case medium = "обычная"
    case high = "важная"
    private var order: Int {
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

struct TodoItem: Identifiable, Equatable, Codable, KeyPathComparable {
    let id: String
    var text: String
    var importance: Importance
    var isDone: Bool
    let creationDate: Date
    var deadline: Date?
    var modificationDate: Date?
    
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
        importance: Importance,
        isDone: Bool = false,
        creationDate: Date = Date(),
        deadline: Date? = nil,
        modificationDate: Date? = nil
    ) {
        self.id = id
        self.text = text
        self.importance = importance
        self.isDone = isDone
        self.deadline = deadline
        self.creationDate = creationDate
        self.modificationDate = modificationDate
    }
}

// MARK: - CustomStringConvertible
extension TodoItem: CustomStringConvertible, CustomDebugStringConvertible {
    var description: String {
        var desc = "TodoItem(id: \(id),\n"
        desc += "\ttext: \"\(text)\",\n"
        desc += "\timportance: \(importance.rawValue),\n"
        desc += "\tisDone: \(isDone),\n"
        desc += "\tcreationDate: \(creationDate.toString()),\n"
        desc += "\tdeadline: \(deadline.toString()),\n"
        desc += "\tmodificationDate: \(modificationDate.toString()))"
        return desc
    }
    var debugDescription: String {
        return description
    }
}
