//
//  ColorPickerRowView.swift
//  DailyDeeds
//
//  Created by Дмитрий Корчагин on 6/30/24.
//

import SwiftUI

struct ColorPickerRowView: View {
    @Binding
    var selectedColor: Color
    @Binding
    var isShowingColorPicker: Bool
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 2) {
                Text("Цвет")
                Text(selectedColor.hexString)
                    .font(.system(size: 14))
                    .foregroundStyle(Color.labelPrimary)
                    .padding(2)
                    .background(Color.backiOSPrimary)
                    .clipShape(.rect(cornerRadius: 4))
            }

            Spacer()

            Button {
                isShowingColorPicker.toggle()
            } label: {
                GradientCircleView(
                    fillColor: selectedColor,
                    separatorColor: Color.backSecondary
                )
            }
        }
        .frame(height: 56)
    }
}
