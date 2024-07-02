//
//  CSVParsable.swift
//  DailyDeeds
//
//  Created by Дмитрий Корчагин on 6/14/24.
//

import Foundation

protocol CSVParsable {
    associatedtype CSVType
    var csv: CSVType { get }
    static func parse(csv: CSVType) -> Self?
}

extension CSVParsable {
    static func buildCSV(@CSVBuilder build: () -> String) -> String { build() }
}

extension TodoItem: CSVParsable {
    /// CSV representation of the current TodoItem object.
    var csv: String {
        return TodoItem.buildCSV {
            id
            text
            isDone
            importance
            hexColor
            creationDate
            deadline
            modificationDate
        }
    }
    
    /// A function for parsing SCV and creating a TodoItem object.
    /// - Parameter dict: A SCV object in the form of a `String'.
    /// - Returns: Returns the `TodoItem` object if parsing was successful, otherwise it returns `nil'.
    static func parse(csv: String) -> TodoItem? {
        let csvArray = csv.splitByUnescaped(separator: ",")

        guard let id = csvArray[safe: 0],
              let text = csvArray[safe: 1],
              let isDoneString = csvArray[safe: 2],
              isDoneString == "true" || isDoneString == "false",
              let importanceRawValue = csvArray[safe: 3],
              let importance = Importance(rawValue: importanceRawValue),
              let hexColor = csvArray[safe: 4],
              let creationDateString = csvArray[safe: 5],
              let creationDate = creationDateString.toDate()
        else { return nil }
        
        let isDone = isDoneString == "true"
        let deadline = csvArray[safe: 6]?.toDate()
        let modificationDate = csvArray[safe: 7]?.toDate()
        
        let category: Category?
        if let csvCategory = csvArray[safe: 8] {
            category = Category.parse(csv: csvCategory)
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
            category: category
        )
    }
}
