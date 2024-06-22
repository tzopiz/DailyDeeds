//
//  Date.swift
//  DailyDeeds
//
//  Created by Дмитрий Корчагин on 6/17/24.
//

import Foundation

extension Date {
    
    // FIXME: - Converter -
    func toString(format: String = "yyyy-MM-dd HH:mm:ss") -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        return dateFormatter.string(from: self)
    }
}

extension Optional where Wrapped == Date {
    func toString(format: String = "yyyy-MM-dd HH:mm:ss") -> String {
        switch self {
        case .none:
            return ""
        case .some(let wrapped):
            return wrapped.toString()
        }
    }
}
