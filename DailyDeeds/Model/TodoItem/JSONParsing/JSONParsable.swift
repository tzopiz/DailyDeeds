//
//  JSONParsable.swift
//  DailyDeeds
//
//  Created by Дмитрий Корчагин on 6/14/24.
//

import Foundation

typealias JSONDictionary = [String: Any]
protocol JSONParsable {
    associatedtype JSONType
    var json: JSONType { get }
    
    static func parse(json: JSONType) -> Self?
}

extension JSONParsable {
    static func buildJSON(@JSONBuilder build: () -> JSONType) -> JSONType { build() }
    var jsonString: String? {
        guard let jsonData = try? JSONSerialization.data(withJSONObject: json),
              let jsonString = String(data: jsonData, encoding: .utf8) 
        else { return nil }
        return jsonString
    }
    
    /// Converts a JSON string to an object.
    /// - Parameter jsonString: JSON string.
    /// - Returns: Returns an object created from a JSON string, or null if the conversion failed.
    static func from(jsonString: String) -> Self? {
        guard let jsonData = jsonString.data(using: .utf8),
              let jsonObject = try? JSONSerialization.jsonObject(with: jsonData),
              let json = jsonObject as? Self.JSONType,
              let object = parse(json: json)
        else { return nil }
        return object
    }
}

extension TodoItem: JSONParsable {
    /// JSON representation of the current TodoItem object.
    var json: JSONDictionary {
        return TodoItem.buildJSON {
            (ItemKeys.id.stringValue, id)
            (ItemKeys.text.stringValue, text)
            (ItemKeys.isDone.stringValue, isDone)
            (ItemKeys.importance.stringValue, importance)
            (ItemKeys.creationDate.stringValue, creationDate)
            (ItemKeys.deadline.stringValue, deadline)
            (ItemKeys.modificationDate.stringValue, modificationDate)
        }
    }
    
    /// A function for parsing JSON and creating a TodoItem object.
    /// - Parameter json: A JSON object in the form of `Any'.
    /// - Returns: Returns the `TodoItem` object if parsing was successful, otherwise it returns `nil'.
    static func parse(json dict: JSONDictionary) -> TodoItem? {
        guard let id = dict[ItemKeys.id.stringValue] as? String,
              let text = dict[ItemKeys.text.stringValue] as? String,
              let isDone = dict[ItemKeys.isDone.stringValue] as? Bool,
              let creationTimestamp = dict[ItemKeys.creationDate.stringValue] as? String,
              let creationDate = creationTimestamp.toDate()
        else { return nil }
        
        let deadline = (dict[ItemKeys.deadline.stringValue] as? String)?.toDate()
        let modificationDate = (dict[ItemKeys.modificationDate.stringValue] as? String)?.toDate()
        
        let importance: Importance = {
            guard let importanceRawValue = dict[ItemKeys.importance.stringValue] as? String,
                  let importanceValue = Importance(rawValue: importanceRawValue)
            else { return .medium }
            return importanceValue
        }()

        return TodoItem(
            id: id,
            text: text,
            isDone: isDone,
            importance: importance,
            creationDate: creationDate,
            deadline: deadline,
            modificationDate: modificationDate
        )
    }
}
