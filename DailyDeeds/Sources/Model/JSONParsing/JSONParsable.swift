//
//  JSONParsable.swift
//  DailyDeeds
//
//  Created by Дмитрий Корчагин on 6/14/24.
//

import Foundation
import FileCache

extension TodoItem: JSONParsable {
    /// JSON representation of the current TodoItem object.
    var json: JSONDictionary {
        return TodoItem.buildJSON {
            (CodingKeys.id, id)
            (CodingKeys.text, text)
            (CodingKeys.isDone, isDone)
            (CodingKeys.importance, importance)
            (CodingKeys.hexColor, hexColor)
            (CodingKeys.creationDate, creationDate)
            (CodingKeys.deadline, deadline)
            (CodingKeys.modificationDate, modificationDate)
        }
    }
    
    /// A function for parsing JSON and creating a TodoItem object.
    /// - Parameter json: A JSON object in the form of `Any'.
    /// - Returns: Returns the `TodoItem` object if parsing was successful, otherwise it returns `nil'.
    static func parse(json dict: JSONDictionary) -> TodoItem? {
        guard let id = dict[CodingKeys.id] as? String,
              let text = dict[CodingKeys.text] as? String,
              let isDone = dict[CodingKeys.isDone] as? Bool,
              let creationTimestamp = dict[CodingKeys.creationDate] as? String,
              let creationDate = creationTimestamp.toDate(),
              let hexColor = dict[CodingKeys.hexColor] as? String
        else { return nil }
        
        let deadline = (dict[CodingKeys.deadline] as? String)?.toDate()
        let modificationDate = (dict[CodingKeys.modificationDate] as? String)?.toDate()
        
        let importance: Importance = {
            guard let importanceRawValue = dict[CodingKeys.importance] as? String,
                  let importanceValue = Importance(rawValue: importanceRawValue)
            else { return .medium }
            return importanceValue
        }()
        
        let category: Category?
        if let categoryJSON = dict[CodingKeys.category] as? JSONDictionary {
            category = Category.parse(json: categoryJSON)
        } else {
            category = nil
        }
        

        return TodoItem(
            id: id,
            text: text,
            isDone: isDone,
            importance: importance,
            hexColor: hexColor,
            creationDate: creationDate,
            deadline: deadline,
            modificationDate: modificationDate,
            category: category ?? Category.defaultCategory
        )
    }
}
