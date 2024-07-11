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

enum Settings { }
