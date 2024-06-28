//
//  RswiftResources.swift
//  DailyDeeds
//
//  Created by Дмитрий Корчагин on 6/22/24.
//

import SwiftUI
import RswiftResources

// MARK: - FontResource
extension RswiftResources.FontResource {
    func font(size: CGFloat) -> Font {
        Font.custom(name, size: size)
    }
}

// MARK: - ColorResource
extension RswiftResources.ColorResource {
    var color: Color {
        Color(name)
    }
}

// MARK: - ImageResource
extension RswiftResources.ImageResource {
    var image: Image {
        Image(name)
    }
}

// MARK: - StringResource
extension RswiftResources.StringResource {
    var localizedStringKey: LocalizedStringKey {
        LocalizedStringKey(key.description)
    }

    var text: Text {
        Text(localizedStringKey)
    }
}
