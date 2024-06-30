//
//  CompactVerticalDetailView.swift
//  DailyDeeds
//
//  Created by Дмитрий Корчагин on 6/28/24.
//

import SwiftUI

struct CompactVerticalDetailView<Content: View>: View {
    @ObservedObject
    var todoItem: MutableTodoItem
    let content: Content
    
    @FocusState
    private var isActive: Bool
    
    @State
    private var selectedColor: Color
    @State
    private var isDatePickerVisible: Bool = false
    @State
    private var isShowingColorPicker = false
    
    init(todoItem: MutableTodoItem, @ViewBuilder content: () -> Content) {
        self.content = content()
        self.todoItem = todoItem
        self.selectedColor = Color(hex: todoItem.hexColor)
    }
    
    var body: some View {
        HStack(spacing: 0) {
            TextEditor(text: $todoItem.text)
                .focused($isActive)
                .scrollContentBackground(Res.Color.Back.secondary)
                .clipShape(RoundedRectangle(cornerRadius: 8))
                .padding(
                    !isActive ?
                        .init(top: 16, leading: 16,bottom: 16,trailing: 8) :
                            .init(top: 0, leading: 16, bottom: 0, trailing: 16)
                )
                .background(Res.Color.Back.primary)
            
            if !isActive {
                Form {
                    Section {
                        ImportancePicker(selectedSegment: $todoItem.importance)
                        colorPicker
                        deadlineToggleView
                        datePicker
                    }
                    .listRowBackground(Res.Color.Back.secondary)
                    .listRowInsets(.init(top: 0, leading: 16, bottom: 0, trailing: 16))
                    
                    Section {
                        content
                    }
                    .listRowBackground(Res.Color.Back.secondary)
                    .listRowInsets(.init(top: 0, leading: 16, bottom: 0, trailing: 16))
                }
                .scrollContentBackground(Res.Color.Back.primary)
                .contentMargins([.vertical], 16)
                .contentMargins(.leading, 8)
                .scrollDisabled(isDatePickerVisible ? false : true)
            }
        }
        /* FIXME: smth blinking other views
         .animation(.easeInOut, value: isDatePickerVisible)
         .animation(.easeInOut, value: todoItem.isDeadlineEnabled)
         .animation(.easeInOut, value: isActive)
         */
        .listSectionSpacing(16)
        .toolbarKeyboardView(_isActive)
    }
    
    private var colorPicker: some View {
        ColorPickerRowView(
            selectedColor: $selectedColor,
            isShowingColorPicker: $isShowingColorPicker
        )
        .sheet(isPresented: $isShowingColorPicker, onDismiss: {
            todoItem.hexColor = selectedColor.hexString
        }, content: {
            CustomColorPicker(selectedColor: $selectedColor)
        })
    }
    
    private var deadlineToggleView: some View {
        DeadlineToggleView(
            deadline: $todoItem.deadline,
            isDeadlineEnabled: $todoItem.isDeadlineEnabled,
            isDatePickerVisible: $isDatePickerVisible
        )
    }
    
    @ViewBuilder
    private var datePicker: some View {
        if isDatePickerVisible, !isActive {
            DatePicker("", selection: $todoItem.deadline, displayedComponents: .date)
                .transition(.blurReplace) // FIXME: - not working ...
                .datePickerStyle(.graphical)
        }
    }
}
