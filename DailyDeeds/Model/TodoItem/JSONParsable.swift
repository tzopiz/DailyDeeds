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
    
    /// A function for parsing JSON and creating a TodoItem object.
    /// - Parameter dict: A JSON object in the form of `[String:Any]'.
    /// - Returns: Returns the `TodoItem` object if parsing was successful, otherwise it returns `nil'.
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
