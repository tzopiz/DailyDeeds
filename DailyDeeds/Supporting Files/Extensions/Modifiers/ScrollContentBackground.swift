//
//  ScrollContentBackground.swift
//  DailyDeeds
//
//  Created by Дмитрий Корчагин on 6/30/24.
//

import SwiftUI

struct ScrollContentBackground: ViewModifier {
    let color: Color
    func body(content: Content) -> some View {
        content
            .scrollContentBackground(.hidden)
            .background(color)
    }
}
