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
            (CodingKeys.id.stringValue, id)
            (CodingKeys.text.stringValue, text)
            (CodingKeys.isDone.stringValue, isDone)
            (CodingKeys.importance.stringValue, importance)
            (CodingKeys.hexColor.stringValue, hexColor)
            (CodingKeys.creationDate.stringValue, creationDate)
            (CodingKeys.deadline.stringValue, deadline)
            (CodingKeys.modificationDate.stringValue, modificationDate)
        }
    }
    
    /// A function for parsing JSON and creating a TodoItem object.
    /// - Parameter json: A JSON object in the form of `Any'.
    /// - Returns: Returns the `TodoItem` object if parsing was successful, otherwise it returns `nil'.
    static func parse(json dict: JSONDictionary) -> TodoItem? {
        guard let id = dict[CodingKeys.id.stringValue] as? String,
              let text = dict[CodingKeys.text.stringValue] as? String,
              let isDone = dict[CodingKeys.isDone.stringValue] as? Bool,
              let creationTimestamp = dict[CodingKeys.creationDate.stringValue] as? String,
              let creationDate = creationTimestamp.toDate(),
              let hexColor = dict[CodingKeys.hexColor.stringValue] as? String
        else { return nil }
        
        let deadline = (dict[CodingKeys.deadline.stringValue] as? String)?.toDate()
        let modificationDate = (dict[CodingKeys.modificationDate.stringValue] as? String)?.toDate()
        
        let importance: Importance = {
            guard let importanceRawValue = dict[CodingKeys.importance.stringValue] as? String,
                  let importanceValue = Importance(rawValue: importanceRawValue)
            else { return .medium }
            return importanceValue
        }()

        return TodoItem(
            id: id,
            text: text,
            isDone: isDone,
            importance: importance,
            hexColor: hexColor,
            creationDate: creationDate,
            deadline: deadline,
            modificationDate: modificationDate
        )
    }
}
