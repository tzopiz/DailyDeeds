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
