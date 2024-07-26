//
//  Importance.swift
//  DailyDeeds
//
//  Created by Дмитрий Корчагин on 7/25/24.
//

import Foundation

enum Importance: String, Comparable, Equatable, Codable {
    case low = "low"
    case medium = "basic"
    case high = "important"

    var order: Int {
        switch self {
        case .low: return 0
        case .medium: return 1
        case .high: return 2
        }
    }

    static func < (lhs: Importance, rhs: Importance) -> Bool {
        return lhs.order < rhs.order
    }
}
