//
//  TaskCriteria + FilterType.swift
//  DailyDeeds
//
//  Created by Дмитрий Корчагин on 7/25/24.
//

import Foundation

extension TaskCriteria {
    enum FilterType {
        case notCompletedOnly
        case all
        var isEnabled: Bool {
            self == .notCompletedOnly
        }
    }
}
