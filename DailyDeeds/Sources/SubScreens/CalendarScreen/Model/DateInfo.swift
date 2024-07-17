//
//  DateInfo.swift
//  DailyDeeds
//
//  Created by Дмитрий Корчагин on 7/3/24.
//

import FileCache
import Foundation

// TODO: -
// - [ ] Make normal model

struct DateInfo {
    enum Format {
        case long
        case short
    }

    let date: Date?

    func description(_ format: Format) -> String {
        guard let date = date else { return "Другое" }
        let day = date.toString(format: "dd")
        let month = date.toString(format: "MMM")
        let year = date.toString(format: "YYYY")
        switch format {
        case .long:
            return [day, month, year].joined(separator: " ")
        case .short:
            return [day, month].joined(separator: "\n")
        }
    }
}
