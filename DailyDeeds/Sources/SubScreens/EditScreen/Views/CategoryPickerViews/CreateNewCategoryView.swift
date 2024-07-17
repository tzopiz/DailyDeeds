//
//  CreateNewCategoryView.swift
//  DailyDeeds
//
//  Created by Дмитрий Корчагин on 7/5/24.
//

import SwiftUI

struct CreateNewCategoryView: View {
    @State
    private var text = ""
    @State
    private var color: Color = .white
    @State
    private var isColorPickerShow = false
    @State
    private var isColorEnabled = false
    @Environment(\.dismiss)
    private var dismiss
    @FocusState
    private var isActive: Bool
    var body: some View {
        NavigationStack {
            Form {
                ItemSection(horizontal: 16) {
                    TextField("Название", text: $text, axis: .vertical)
                        .frame(minHeight: 40)
                        .padding(.vertical, 8)
                        .focused($isActive)

                    Toggle("Цветная", isOn: $isColorEnabled)
                        .frame(height: 56)

                    if isColorEnabled {
                        ColorPickerRowView(
                            selectedColor: $color,
                            isShowingColorPicker: $isColorPickerShow
                        )
                        .sheet(isPresented: $isColorPickerShow) {
                            CustomColorPicker(selectedColor: $color)
                                .presentationDetents([.medium])
                        }
                    }
                }
                ItemSection(horizontal: 16) {
                    Button("Сохранить") {
                        Categories.shared.append(
                            Category(
                                name: text,
                                color: isColorEnabled ? color.hexString : nil
                            )
                        )
                        dismiss()
                    }
                    .disabled(text.isEmpty)
                    .frame(height: 56)
                    .frame(maxWidth: .infinity)
                }
            }
            .toolbarKeyboardView(_isActive) // FIXME: - unexpected behavior is present
            .scrollContentBackground(.backPrimary)
            .navigationTitle("Новая категория")
        }
    }
}
