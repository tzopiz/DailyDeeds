//
//  Bool.swift
//  DailyDeeds
//
//  Created by Дмитрий Корчагин on 6/26/24.
//

import Foundation

extension Bool: @retroactive Comparable {
    private var order: Int {
        switch self {
        case true: return 1
        case false: return -1
        }
    }

    public static func < (lhs: Bool, rhs: Bool) -> Bool {
        lhs.order < rhs.order
    }
}
