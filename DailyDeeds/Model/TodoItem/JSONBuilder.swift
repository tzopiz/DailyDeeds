//
//  JSONBuilder.swift
//  DailyDeeds
//
//  Created by Дмитрий Корчагин on 6/17/24.
//

import Foundation

@resultBuilder
struct JSONBuilder {
    static func buildBlock(_ components: JSONType...) -> JSONType {
        var res = JSONType()
        for component in components {
            for (key, value) in component {
                res[key] = value
            }
        }
        return res
    }
    
    static func buildExpression(_ expression: (key: String, value: String)) -> JSONType {
        return [expression.key: expression.value]
    }
    
    static func buildExpression(_ expression: (key: String, value: Date?)) -> JSONType {
        return [expression.key: expression.value.toString()]
    }
    
    static func buildExpression(_ expression: (key: String, value: Importance)) -> JSONType {
        return [expression.key: expression.value.rawValue]
    }
    static func buildExpression(_ expression: (key: String, value: Bool)) -> JSONType {
        return [expression.key: expression.value]
    }
}
