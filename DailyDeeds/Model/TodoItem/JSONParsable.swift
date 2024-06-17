//
//  JSONParsable.swift
//  DailyDeeds
//
//  Created by Дмитрий Корчагин on 6/14/24.
//

import Foundation

protocol JSONParsable {
    associatedtype JSONType
    var json: JSONType { get }
    
    static func parse(json: JSONType) -> Self?
}

extension JSONParsable {
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
    typealias JSONType = [String: Any]
    /// JSON representation of the current TodoItem object.
    var json: JSONType {
        var jsonDict: JSONType = [
            "id": id,
            "text": text,
            "isDone": isDone,
            "creationDate": creationDate.toString()
        ]
        
        if importance != .medium {
            jsonDict["importance"] = importance.rawValue
        }
        
        if let deadline = deadline {
            jsonDict["deadline"] = deadline.toString()
        }
        
        if let modificationDate = modificationDate {
            jsonDict["modificationDate"] = modificationDate.toString()
        }
        
        return jsonDict
    }
    
    /// A function for parsing JSON and creating a TodoItem object.
    /// - Parameter dict: A JSON object in the form of `[String:Any]'.
    /// - Returns: Returns the `TodoItem` object if parsing was successful, otherwise it returns `nil'.
    static func parse(json dict: JSONType) -> TodoItem? {
        guard let id = dict["id"] as? String,
              let text = dict["text"] as? String,
              let creationTimestamp = dict["creationDate"] as? String,
              let isDoneValue = dict["isDone"] as? Bool,
              let creationDate = creationTimestamp.toDate()
        else { return nil }
        
        let isDone = isDoneValue
        
        let importance: Importance
        if let importanceRawValue = dict["importance"] as? String,
           let importanceValue = Importance(rawValue: importanceRawValue) {
            importance = importanceValue
        } else {
            importance = .medium
        }
        
        let deadline: Date?
        let deadlineTimestamp = dict["deadline"] as? String
        if let deadlineTimestamp = deadlineTimestamp {
            deadline = deadlineTimestamp.toDate()
        } else {
            deadline = nil
        }
        
        let modificationDate: Date?
        let modificationTimestamp = dict["modificationDate"] as? String
        if let modificationTimestamp = modificationTimestamp {
            modificationDate = modificationTimestamp.toDate()
        } else {
            modificationDate = nil
        }
        
        return TodoItem(
            id: id,
            text: text,
            importance: importance,
            isDone: isDone,
            creationDate: creationDate,
            deadline: deadline,
            modificationDate: modificationDate
        )
    }
}
