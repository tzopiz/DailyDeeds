//
//  StorageType.swift
//  DailyDeeds
//
//  Created by Дмитрий Корчагин on 7/25/24.
//

import Foundation

enum StorageType {
    case swiftData
    case sqlite
    
    mutating func toggle() {
        switch self {
        case .swiftData:
            self = .sqlite
        case .sqlite:
            self = .swiftData
        }
    }
}
