//
//  Category.swift
//  DailyDeeds
//
//  Created by Дмитрий Корчагин on 7/2/24.
//

import FileCache
import Foundation
import SwiftData

@Model
final class Category: Identifiable, Equatable, Sendable, Hashable, CSVParsable, JSONParsable {
    enum CodingKeys {
        static let id = "id"
        static let name = "name"
        static let color = "color"
    }
    
    @Attribute(.unique)
    let id: String
    let name: String
    let color: String?
    
    init(id: String = UUID().uuidString, name: String, color: String? = nil) {
        self.id = id
        self.name = name
        self.color = color
    }

    static func == (lhs: Category, rhs: Category) -> Bool {
        return lhs.id == rhs.id
    }

    static let `default` = Category(name: "Без категории")
}
