//
//  Settings.swift
//  DailyDeeds
//
//  Created by Дмитрий Корчагин on 6/27/24.
//

import Foundation

@propertyWrapper
struct UserDefault<T> {
    let key: String
    let defaultValue: T
    
    var wrappedValue: T {
        get {
            UserDefaults.standard.object(forKey: key) as? T ?? defaultValue
        }
        set {
            UserDefaults.standard.setValue(newValue, forKey: key)
        }
    }
}

enum Settings {
    @UserDefault(
        key: String(describing: Category.self),
        defaultValue: [
            Category(name: "Работа", color: "#FF0000"),
            Category(name: "Учеба", color: "#0000FF"),
            Category(name: "Хобби", color: "00FF00"),
            Category(name: "Без категории")
        ]
    )
    static var categories: [Category]
}
