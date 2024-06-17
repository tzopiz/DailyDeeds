//
//  CSVParsable.swift
//  DailyDeeds
//
//  Created by Дмитрий Корчагин on 6/14/24.
//

import Foundation

protocol CSVParsable {
    var csv: String { get }
    static func parse(csv: String) -> Self?
}

extension TodoItem: CSVParsable {
    /// CSV representation of the current TodoItem object.
    var csv: String {
        var csvArray = [
            id,
            text,
            importance.rawValue,
            isDone ? "true" : "false",
            creationDate.toString()
        ]
        csvArray.append(deadline.toString())
        csvArray.append(modificationDate.toString())
        
        return csvArray.joined(separator: ",")
    }
    
    /// A function for parsing SCV and creating a TodoItem object.
    /// - Parameter dict: A SCV object in the form of a `String'.
    /// - Returns: Returns the `TodoItem` object if parsing was successful, otherwise it returns `nil'.
    static func parse(csv: String) -> TodoItem? {
        let csvArray = csv.components(separatedBy: ",")
        
        guard let id = csvArray[safe: 0],
              let text = csvArray[safe: 1],
              let importanceRawValue = csvArray[safe: 2],
              let importance = Importance(rawValue: importanceRawValue),
              let isDoneString = csvArray[safe: 3],
              let creationDateString = csvArray[safe: 4],
              let creationDate = creationDateString.toDate()
        else { return nil }
        
        let isDone = isDoneString == "true"
        
        let deadlineString = csvArray[safe: 5]
        let deadline: Date?
        if let deadlineString = deadlineString {
            deadline = deadlineString.toDate()
        } else {
            deadline = nil
        }
        
        let modificationDateString = csvArray[safe: 6]
        let modificationDate: Date?
        if let modificationDateString = modificationDateString {
            modificationDate = modificationDateString.toDate()
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
