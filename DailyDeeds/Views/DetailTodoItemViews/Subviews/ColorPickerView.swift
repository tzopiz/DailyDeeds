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
        VStack {
            Text("Выберите цвет")
                .font(.headline)
                .padding()
            
            ColorPicker("Цвет", selection: $selectedColor)
                .padding()
                .frame(maxWidth: 300)
            
            Text("Выбранный цвет")
                .font(.headline)
                .padding()
            
            RoundedRectangle(cornerRadius: 10)
                .fill(selectedColor)
                .frame(width: 100, height: 100)
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(Color.gray, lineWidth: 1)
                )
            
            Spacer()
        }
        .padding()
    }
}

#Preview {
    ColorPickerView(selectedColor: .white)
}
