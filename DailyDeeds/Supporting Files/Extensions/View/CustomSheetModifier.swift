//
//  CustomSheetModifier.swift
//  DailyDeeds
//
//  Created by Дмитрий Корчагин on 6/29/24.
//

import SwiftUI

struct CustomSheetModifier<Element: Identifiable, Preview: View>: ViewModifier {
    @Binding
    var item: Element?
    var isPresented: Bool
    var action: (Element) -> Preview
    
    func body(content: Content) -> some View {
        if isPresented {
            content
                .background(
                    EmptyView()
                        .sheet(item: $item) { item in
                            action(item)
                        }
                )
        } else {
            content
        }
    }
}
