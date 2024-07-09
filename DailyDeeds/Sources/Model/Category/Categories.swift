//
//  Categories.swift
//  DailyDeeds
//
//  Created by Дмитрий Корчагин on 7/5/24.
//

import Foundation

final class Categories: Sendable {

    private init() { }
    
    static let shared = Categories()
    
    var categories: [Category] {
        defaultCategories + userCategories
    }
    
    var userCategories: [Category] {
        return _categories
    }

    private var _categories = [Category]()
    let defaultCategories = [
        Category(name: "Работа", color: "#FF0000"),
        Category(name: "Учеба", color: "#0000FF"),
        Category(name: "Хобби", color: "#00FF00"),
        Category(name: "Без категории")
    ]

    func append(_ category: Category) {
        if !_categories.contains(where: { $0.name == category.name }) {
            _categories.append(category)
        }
    }

    func remove(atOffsets offsets: IndexSet) {
        _categories.remove(atOffsets: offsets)
    }
}
