//
//  Date.swift
//  DailyDeeds
//
//  Created by Дмитрий Корчагин on 7/25/24.
//

import Foundation

extension Date {
    init(_ value: Int) {
        let timeInterval = TimeInterval(value)
        self.init(timeIntervalSince1970: timeInterval)
    }
}
