//
//  JSONBuilder 2.swift
//  DailyDeeds
//
//  Created by Дмитрий Корчагин on 6/17/24.
//

import FileCache
import Foundation

extension CSVBuilder {
    static func buildExpression(_ expression: Importance) -> String {
        return expression.rawValue
    }
}
