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
        guard expression.value != .medium else { return [:] }
        return [expression.key: expression.value.rawValue]
    }
}
