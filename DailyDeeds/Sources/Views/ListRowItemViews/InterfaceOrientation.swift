//
//  InterfaceOrientation.swift
//  DailyDeeds
//
//  Created by Дмитрий Корчагин on 6/30/24.
//

import SwiftUI

enum InterfaceOrientation {
    case compactWidthCompactHeight
    case compactWidthRegularHeight
    case regularWidthCompactHeight
    case regularWidthRegularHeight
    case unknown

    enum DeviceType {
        case small
        case large

        var isSmall: Bool {
            self == .small
        }
    }

    var deviceType: DeviceType {
        switch self {
        case .compactWidthCompactHeight, .compactWidthRegularHeight, .regularWidthCompactHeight:
            return .small
        case .regularWidthRegularHeight:
            return .large
        case .unknown:
            return .small
        }
    }

    init(horizontal: UserInterfaceSizeClass?, vertical: UserInterfaceSizeClass?) {
        switch (horizontal, vertical) {
        case (.compact, .compact):
            self = .compactWidthCompactHeight
        case (.compact, .regular):
            self = .compactWidthRegularHeight
        case (.regular, .compact):
            self = .regularWidthCompactHeight
        case (.regular, .regular):
            self = .regularWidthRegularHeight
        default:
            self = .unknown
        }
    }
}
