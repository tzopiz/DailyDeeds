//
//  String.swift
//  DailyDeeds
//
//  Created by Дмитрий Корчагин on 6/17/24.
//

import Foundation

extension String {
    func toDate(format: String = "yyyy-MM-dd HH:mm:ss") -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        return dateFormatter.date(from: self)
    }
}
