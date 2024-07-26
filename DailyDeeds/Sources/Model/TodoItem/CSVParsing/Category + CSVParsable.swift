//
//  Category + CSVParsable.swift
//  DailyDeeds
//
//  Created by Дмитрий Корчагин on 7/18/24.
//

import CocoaLumberjackSwift
import FileCache
import Foundation

extension Category {
    var csv: String {
        Category.buildCSV {
            id
            name
            color
        }
    }

    static func parse(csv: String) -> Category? {
        let csvArray = csv.splitByUnescaped(separator: ",")
        guard let id = csvArray[safe: 0], let name = csvArray[safe: 1] else {
            DDLogError("Category.\(#function): Failed parse Category object")
            return nil
        }
        return Category(id: id, name: name, color: csvArray[safe: 1])
    }
}
