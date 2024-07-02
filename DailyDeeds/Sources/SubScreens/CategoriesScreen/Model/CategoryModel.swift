//
//  CategoryModel.swift
//  DailyDeeds
//
//  Created by Дмитрий Корчагин on 7/2/24.
//

import Foundation

struct CategoryModel {
    
    private(set) var items: [Category]
    private var defaultCategories: [Category]
    
    init() {
        self.defaultCategories = [
            Category(name: "Работа", color: "#FF0000"),  // Красный
            Category(name: "Учеба", color: "#00FF00"),   // Зеленый
            Category(name: "Хобби", color: "#0000FF"),   // Синий
            Category(name: "Другое")
        ]
        self.items = defaultCategories
    }
    
    mutating func addCategory(name: String, color: String? = nil) {
        let newCategory = Category(name: name, color: color)
        items.append(newCategory)
    }
    
    mutating func removeCategory(at index: Int) -> Bool {
        let category = items[index]
        if !isDefaultCategory(category) {
            items.remove(at: index)
            return true
        }
        return false
    }
    
    private func isDefaultCategory(_ category: Category) -> Bool {
        return defaultCategories.contains(category)
    }
}

