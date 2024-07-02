//
//  Category.swift
//  DailyDeeds
//
//  Created by Дмитрий Корчагин on 7/2/24.
//

import Foundation

struct Category: Equatable, Hashable, CSVParsable, JSONParsable {
    enum CodingKeys {
        static let name = "name"
        static let color = "color"
    }
    
    let name: String
    let color: String?
    
    init(name: String, color: String? = nil) {
        self.name = name
        self.color = color
    }
    
    static func == (lhs: Category, rhs: Category) -> Bool {
        return lhs.name == rhs.name && lhs.color == rhs.color
    }
}

// MARK: - JSONParsable
extension Category {
    var json: JSONDictionary {
        Category.buildJSON {
            (CodingKeys.name, name)
            (CodingKeys.color, color)
        }
    }
    
    static func parse(json dict: JSONDictionary) -> Category? {
        guard let name = dict[CodingKeys.name] as? String
        else { return nil }
        return Category(name: name, color: dict[CodingKeys.color] as? String)
    }
}

// MARK: - CSVParsable
extension Category {
    var csv: String {
        Category.buildCSV {
            name
            color
        }
    }
    
    static func parse(csv: String) -> Category? {
        let csvArray = csv.splitByUnescaped(separator: ",")
        guard let name = csvArray[safe: 0] else { return nil }
        return Category(name: name, color: csvArray[safe: 1])
    }
}
