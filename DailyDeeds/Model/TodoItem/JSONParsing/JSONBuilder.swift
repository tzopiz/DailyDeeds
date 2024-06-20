//
//  JSONBuilder.swift
//  DailyDeeds
//
//  Created by Дмитрий Корчагин on 6/17/24.
//

import Foundation

@resultBuilder
struct JSONBuilder {
    static func buildBlock(_ components: TodoItem.JSONType...) -> JSONDictionary {
        components.reduce(into: JSONDictionary()) { result, dictionary in
            for (key, value) in dictionary {
                result[key] = value
            }
        }
    }
    
    static func buildExpression(_ expression: (key: String, value: String)) -> JSONDictionary {
        return [expression.key: expression.value]
    }
    
    static func buildExpression(_ expression: (key: String, value: Date?)) -> JSONDictionary {
        return [expression.key: expression.value.toString()]
    }
    
    static func buildExpression(_ expression: (key: String, value: Importance)) -> JSONDictionary {
        guard expression.value != .medium else { return [:] }
        return [expression.key: expression.value.rawValue]
    }
    static func buildExpression(_ expression: (key: String, value: Bool)) -> JSONDictionary {
        return [expression.key: expression.value]
    }
}
