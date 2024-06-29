//
//  View.swift
//  DailyDeeds
//
//  Created by Дмитрий Корчагин on 6/29/24.
//

import SwiftUI

extension View {
    func sheet<Element: Identifiable, Preview: View>(
        isPresented: Bool,
        item: Binding<Element?>,
        action: @escaping (Element) -> Preview
    ) -> some View {
        self.modifier(
            CustomSheetModifier(
                item: item,
                isPresented: isPresented,
                action: action
            )
        )
    }
    func scrollContentBackground(_ color: Color) -> some View {
        self.modifier(ScrollContentBackground(color: color))
    }
}
