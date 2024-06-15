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

// MARK: - CSVParsable
extension TodoItem: CSVParsable {
    var csv: String {
        var csvArray = [
            id,
            text,
            importance.rawValue,
            isDone ? "true" : "false",
            TodoItem.string(from: creationDate)
        ]

        csvArray.append(TodoItem.string(from: deadline))
        csvArray.append(TodoItem.string(from: modificationDate))
        
        return csvArray.joined(separator: ",")
    }
    
    static func parse(csv: String) -> TodoItem? {
        let csvArray = csv.components(separatedBy: ",")
        
        guard let id = csvArray[safe: 0],
              let text = csvArray[safe: 1],
              let importanceRawValue = csvArray[safe: 2],
              let importance = Importance(rawValue: importanceRawValue),
              let isDoneString = csvArray[safe: 3],
              let creationDateString = csvArray[safe: 4],
              let creationDate = date(from: creationDateString)
        else { return nil }
        
        let isDone = isDoneString == "true"
        
        let deadlineString = csvArray[safe: 5]
        let deadline = deadlineString != nil ? date(from: deadlineString!) : nil
        
        let modificationDateString = csvArray[safe: 6]
        let modificationDate = modificationDateString != nil ? date(from: modificationDateString!) : nil
        
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

extension Array {
    subscript(safe index: Index) -> Element? {
        return indices.contains(index) ? self[index] : nil
    }
}
