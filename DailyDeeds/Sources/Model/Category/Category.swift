//
//  Category.swift
//  DailyDeeds
//
//  Created by Дмитрий Корчагин on 7/2/24.
//

import FileCache
import Foundation

struct Category: Identifiable, Equatable, Hashable, CSVParsable, JSONParsable {
    enum CodingKeys {
        static let id = "id"
        static let name = "name"
        static let color = "color"
    }

    let id: String
    let name: String
    let color: String?

    init(_ id: String = UUID().uuidString, name: String, color: String? = nil) {
        self.id = id
        self.name = name
        self.color = color
    }

    static func == (lhs: Category, rhs: Category) -> Bool {
        return lhs.name == rhs.name && lhs.color == rhs.color
    }

    static var defaultCategory: Category {
        return Category(name: "Без категории")
    }
}

// MARK: - JSONParsable
extension Category {
    var json: JSONDictionary {
        Category.buildJSON {
            (CodingKeys.id, id)
            (CodingKeys.name, name)
            (CodingKeys.color, color)
        }
    }

    static func parse(json dict: JSONDictionary) -> Category? {
        guard let id = dict[CodingKeys.id] as? String,
              let name = dict[CodingKeys.name] as? String
        else { return Category.defaultCategory }
        return Category(id, name: name, color: dict[CodingKeys.color] as? String)
    }
}

// MARK: - CSVParsable
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
        guard let id = csvArray[safe: 0],
              let name = csvArray[safe: 1]
        else { return nil }
        return Category(id, name: name, color: csvArray[safe: 1])
    }
}
