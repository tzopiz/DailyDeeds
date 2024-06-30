//
//  Date.swift
//  DailyDeeds
//
//  Created by Дмитрий Корчагин on 6/17/24.
//

import Foundation

extension Date {
    enum StripTimeType: CaseIterable {
        case days
        case minutes
    }
    
    static var calendar: Calendar = {
        var calendar = Calendar(identifier: .gregorian)
        calendar.firstWeekday = 2
        return calendar
    }()
    
    var tomorrow: Date {
        return Calendar.current.date(byAdding: .day, value: 1, to: self) ?? self
    }
    
    func toString(format: String = "yyyy-MM-dd HH:mm:ss") -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        return dateFormatter.string(from: self)
    }
    
    func strip(to stripTimeType: Date.StripTimeType) -> Date {
        switch stripTimeType {
        case .days:
            let components = Date.calendar.dateComponents([.year, .month, .day], from: self)
            return Date.calendar.date(from: components) ?? self
        case .minutes:
            let components = Date.calendar.dateComponents([.year, .month, .day, .hour, .minute], from: self)
            return Date.calendar.date(from: components) ?? self
        }
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
