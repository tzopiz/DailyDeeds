//
//  ToolbarButtonKeyboard.swift
//  DailyDeeds
//
//  Created by Дмитрий Корчагин on 6/30/24.
//

import SwiftUI

struct ToolbarButtonKeyboard<Label: View>: ViewModifier {
    let label: Label
    init(@ViewBuilder label: @escaping () -> Label) {
        self.label = label()
    }
    func body(content: Content) -> some View {
        content
            .toolbar {
                ToolbarItem(placement: .keyboard) {
                    label
                }
            }
    }
}
