//
//  ColorPickerView.swift
//  DailyDeeds
//
//  Created by Дмитрий Корчагин on 6/27/24.
//

import SwiftUI

struct ColorPickerView: View {
    @State 
    var selectedColor: Color
    
    var body: some View {
        ColorPicker("Цвет", selection: $selectedColor)
            .padding()
            .frame(maxWidth: 300)
    }
}

#Preview {
    ColorPickerView(selectedColor: .white)
}
