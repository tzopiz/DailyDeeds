//
//  RegularVerticalDetailView.swift
//  DailyDeeds
//
//  Created by Дмитрий Корчагин on 6/28/24.
//

import SwiftUI

struct RegularVerticalDetailView<Content: View>: View {
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
        Form {
            Section {
                // FIXME: - tap work only on label(not on full textfield)
                TextField("Что мне сделать?", text: $todoItem.text, axis: .vertical)
                    .frame(minHeight: 120, alignment: .topLeading)
                    .padding(.all, 12)
                    .focused($isActive)
            }
            .listRowBackground(Color.backSecondary)
            .listRowInsets(.init())
            
            Section {
                ImportancePicker(selectedSegment: $todoItem.importance)
                colorPicker
                deadlineToggleView
                if isDatePickerVisible, !isActive {
                    datePicker
                }
            }
            .listRowBackground(Color.backSecondary)
            .listRowInsets(.init(top: 0, leading: 16, bottom: 0, trailing: 16))
            
            Section {
                content
            }
            .listRowBackground(Color.backSecondary)
            .listRowInsets(.init(top: 0, leading: 16, bottom: 0, trailing: 16))
        }
        // FIXME: blinking
        .animation(.easeInOut, value: isDatePickerVisible)
        .animation(.easeInOut, value: todoItem.isDeadlineEnabled)
        .scrollIndicators(.hidden)
        .listSectionSpacing(16)
        .scrollContentBackground(Color.backPrimary)
        .contentMargins(.all, 16)
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
    
    private var datePicker: some View {
        DatePicker("", selection: $todoItem.deadline, displayedComponents: .date)
            .transition(.scale)
            .datePickerStyle(.graphical)
    }
}
