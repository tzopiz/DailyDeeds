//
//  JSONParsable.swift
//  DailyDeeds
//
//  Created by Дмитрий Корчагин on 6/14/24.
//

import FileCache
import Foundation

extension TodoItem: JSONParsable {
    /// JSON representation of the current TodoItem object.
    var json: JSONDictionary {
        return TodoItem.buildJSONDictionary {
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
              let creationTimestamp = dict[CodingKeys.creationDate] as? TimeInterval,
              let hexColor = dict[CodingKeys.hexColor] as? String else {
            return nil
        }
        
        let deadline: Date? = {
            guard let interval = dict[CodingKeys.deadline] as? TimeInterval else {
                return nil
            }
            return Date(timeIntervalSince1970: interval)
        }()
        
        let modificationDate: Date? = {
            guard let interval = dict[CodingKeys.modificationDate] as? TimeInterval else {
                return nil
            }
            return Date(timeIntervalSince1970: interval)
        }()

        let importance: Importance = {
            guard let importanceRawValue = dict[CodingKeys.importance] as? String,
                  let importanceValue = Importance(rawValue: importanceRawValue) else {
                return .medium
            }
            return importanceValue
        }()

        let category: Category = {
            guard let categoryJSON = dict[CodingKeys.category] as? JSONDictionary,
                  let category = Category.parse(json: categoryJSON) else {
                return .defaultCategory
            }
            return category
        }()

        let creationDate = Date(timeIntervalSince1970: creationTimestamp)

        return TodoItem(
            id: id,
            text: text,
            isDone: isDone,
            importance: importance,
            hexColor: hexColor,
            creationDate: creationDate,
            deadline: deadline,
            modificationDate: modificationDate,
            category: category
        )
    }
}
