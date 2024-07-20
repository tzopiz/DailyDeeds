//
//  JSONBuilder.swift
//  DailyDeeds
//
//  Created by Дмитрий Корчагин on 6/17/24.
//

import FileCache
import Foundation

extension JSONBuilder {
    static func buildExpression(_ expression: (key: String, value: Importance)) -> JSONDictionary {
        return [expression.key: expression.value.rawValue]
    }
    
    static func buildExpression(_ expression: (key: String, value: Category)) -> JSONDictionary {
        return [expression.key: expression.value.json]
    }
    
    static func buildExpression(_ expression: (key: String, value: Date?)) -> JSONDictionary {
        guard let value = expression.value?.timeIntervalSince1970 else {
            return [:]
        }
        return [expression.key: Int(value)]
    }
}
