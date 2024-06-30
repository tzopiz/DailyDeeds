//
//  DefaultKeyboardView.swift
//  DailyDeeds
//
//  Created by Дмитрий Корчагин on 6/30/24.
//

import SwiftUI

struct DefaultKeyboardView: View {
    @FocusState
    var isActive: Bool
    let upAction: Void?
    let downAction: Void?
    var body: some View {
        HStack {
            Button {
                upAction
            } label: {
                Image(systemName: "chevron.up")
            }
            
            Divider()
            Button {
                downAction
            } label: {
                Image(systemName: "chevron.down")
            }
            Divider()
            Spacer()
            Divider()
            Button("Готово") {
                isActive = false
            }
        }
    }
}
