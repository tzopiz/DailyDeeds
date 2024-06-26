//
//  Resources.swift
//  DailyDeeds
//
//  Created by Дмитрий Корчагин on 6/22/24.
//

import SwiftUI

enum Res {
    enum Image {
        static let arrowDown = R.image.arrowDown.image
        static let exclamationmark2 = R.image.exclamationmark2.image
    }
    enum Color {
        enum Label {
            static let primary = R.color.labelPrimary.color
            static let secondary = R.color.labelSecondary.color
            static let tertiary = R.color.labelTertiary.color
            static let disable = R.color.labelDisable.color
        }
        
        enum Back {
            static let elevated = R.color.backElevated.color
            static let Primary = R.color.backPrimary.color
            static let iOSPrimary = R.color.backiOSPrimary.color
            static let secondary = R.color.backSecondary.color
        }
        
        enum Support {
            static let overlay = R.color.supportOverlay.color
            static let separator = R.color.supportSeparator.color
            static let navBarBlur = R.color.supportNavBarBlur.color
        }
        
        static let white = R.color.colorWhite.color
        static let red = R.color.colorRed.color
        static let green = R.color.colorGreen.color
        static let blue = R.color.colorBlue.color
        static let gray = R.color.colorGray.color
        static let lightGray = R.color.colorLightGray.color
        static let clear = SwiftUI.Color.clear
    }
}


