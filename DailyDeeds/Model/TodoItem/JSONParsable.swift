//
//  JSONParsable.swift
//  DailyDeeds
//
//  Created by Дмитрий Корчагин on 6/14/24.
//

import Foundation

/// Протокол для объектов, которые могут быть инициализированы из JSON и представлены в JSON формате.
protocol JSONParsable {
    associatedtype JSONType
    /// Функция для разбора JSON и создания объекта.
    /// - Parameter json: JSON объект в виде Any.
    /// - Returns: Возвращает объект, инициализированный из JSON, или nil, если разбор не удался.
    static func parse(json: JSONType) -> Self?
    
    /// Вычислимое свойство, возвращающее JSON представление текущего объекта.
    var json: JSONType { get }
}

extension JSONParsable {
    /// Преобразует объект в JSON строку.
    var jsonString: String? {
        guard let jsonData = try? JSONSerialization.data(withJSONObject: json),
              let jsonString = String(data: jsonData, encoding: .utf8) 
        else { return nil }
        return jsonString
    }
    
    /// Преобразует JSON строку в объект.
    /// - Parameter jsonString: JSON строка.
    /// - Returns: Возвращает объект, созданный из JSON строки, или nil, если преобразование не удалось.
    static func from(jsonString: String) -> Self? {
        guard let jsonData = jsonString.data(using: .utf8),
              let jsonObject = try? JSONSerialization.jsonObject(with: jsonData),
              let json = jsonObject as? Self.JSONType,
              let object = parse(json: json)
        else { return nil }
        return object
    }
}

// MARK: - JSONParsable
extension TodoItem: JSONParsable {
    typealias JSONType = [String: Any]
    /// Вычислимое свойство, которое возвращает JSON представление текущего объекта TodoItem.
    var json: JSONType {
        var jsonDict: [String: Any] = [
            "id": id,
            "text": text,
            "isDone": isDone,
            "creationDate": creationDate.timeIntervalSince1970
        ]
        
        if let deadline = deadline {
            jsonDict["deadline"] = deadline.timeIntervalSince1970
        }
        
        if let modificationDate = modificationDate {
            jsonDict["modificationDate"] = modificationDate.timeIntervalSince1970
        }
        
        if importance != .medium {
            jsonDict["importance"] = importance.rawValue
        }
        
        return jsonDict
    }
    
    /// Функция для разбора JSON и создания объекта TodoItem.
    /// - Parameter json: JSON объект в виде Any.
    /// - Returns: Возвращает объект TodoItem, если разбор удался, иначе возвращает nil.
    static func parse(json dict: JSONType) -> TodoItem? {
        guard let id = dict["id"] as? String,
              let text = dict["text"] as? String,
              let importanceRawValue = dict["importance"] as? String,
              let importance = Importance(rawValue: importanceRawValue),
              let creationTimestamp = dict["creationDate"] as? TimeInterval
        else { return nil }
        
        let deadlineTimestamp = dict["deadline"] as? TimeInterval
        let deadline: Date? = deadlineTimestamp != nil ? Date(timeIntervalSince1970: deadlineTimestamp!) : nil
        let isDone = dict["isDone"] as? Bool ?? false
        let modificationTimestamp = dict["modificationDate"] as? TimeInterval
        let modificationDate: Date? = modificationTimestamp != nil ? Date(timeIntervalSince1970: modificationTimestamp!) : nil
        
        return TodoItem(
            id: id,
            text: text,
            importance: importance,
            isDone: isDone,
            creationDate: Date(timeIntervalSince1970: creationTimestamp),
            deadline: deadline,
            modificationDate: modificationDate
        )
    }
}
