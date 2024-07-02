//
//  JSONBuilder 2.swift
//  DailyDeeds
//
//  Created by Дмитрий Корчагин on 6/17/24.
//

import Foundation

@resultBuilder
struct CSVBuilder {
    static func buildBlock(_ components: String...) -> String {
        return components.joined(separator: ",")
    }
    
    static func buildExpression(_ expression: String) -> String {
        return expression.escapeSpecialCharacters(",")
    }
    
    static func buildExpression(_ expression: String?) -> String {
        if let str = expression {
            return str.escapeSpecialCharacters(",")
        } else {
            return ""
        }
    }
    
    static func buildExpression(_ expression: Importance) -> String {
        return expression.rawValue
    }
    
    static func buildExpression(_ expression: Date?) -> String {
        return expression.toString()
    }
    
    static func buildExpression(_ expression: Bool) -> String {
        return expression.description
    }
}
