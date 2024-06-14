//
//  TodoItem.swift
//  DailyDeeds
//
//  Created by Дмитрий Корчагин on 6/14/24.
//

import Foundation

/// Возможные уровни важности задачи.
enum Importance: String, Comparable, Equatable {
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

/// Структура представляет задачу с определенными характеристиками.
struct TodoItem: Identifiable, Equatable {
    /// Уникальный идентификатор задачи.
    let id: String
    
    /// Описание задачи.
    let text: String
    
    /// Уровень важности задачи.
    let importance: Importance
    
    /// Флаг, указывающий выполнена ли задача.
    var isDone: Bool
    
    /// Дата создания задачи. Обязательное поле.
    let creationDate: Date
    
    /// Дедлайн задачи. Может быть nil, если дедлайн не задан.
    let deadline: Date?
    
    /// Дата последнего изменения задачи. Может быть nil, если задача не изменялась.
    var modificationDate: Date?
    
    /// Инициализирует новый экземпляр задачи TodoItem.
    ///
    /// - Parameters:
    ///   - id: Уникальный идентификатор задачи. По умолчанию генерируется новый UUID.
    ///   - text: Описание задачи.
    ///   - importance: Уровень важности задачи (low, medium, high).
    ///   - isDone: Флаг, указывающий выполнена ли задача. По умолчанию false.
    ///   - creationDate: Дата создания задачи. По умолчанию текущая дата и время.
    ///   - deadline: Дедлайн задачи. По умолчанию nil.
    ///   - modificationDate: Дата последнего изменения задачи. По умолчанию nil.
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
        // !!!: FIXME: - change to what? to String? -
        self.deadline = deadline
        self.creationDate = creationDate
        self.modificationDate = modificationDate
    }
    
    private static let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        return formatter
    }()
    static func date(from dateString: String) -> Date? {
        return dateFormatter.date(from: dateString)
    }
    static func string(from date: Date?) -> String {
        guard let date = date else { return "" }
        return dateFormatter.string(from: date)
    }
}


// MARK: - CustomStringConvertible
extension TodoItem: CustomStringConvertible, CustomDebugStringConvertible {
    var description: String {
        var desc = "TodoItem(id: \(id),\n"
        desc += "\ttext: \"\(text)\",\n"
        desc += "\timportance: \(importance.rawValue),\n"
        desc += "\tisDone: \(isDone),\n"
        desc += "\tcreationDate: \(TodoItem.string(from: creationDate)),\n"
        desc += "\tdeadline: \(TodoItem.string(from: deadline)),\n"
        desc += "\tmodificationDate: \(TodoItem.string(from: modificationDate)))"
        return desc
    }
    var debugDescription: String {
        return description
    }
}
