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
                        importanceView
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
                .scrollContentBackground(.hidden)
                .background(Res.Color.Back.primary)
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
        .toolbar {
            ToolbarItem(placement: .keyboard) {
                toolbarButtonKeyboardView
            }
        }
    }
    
    private var importanceView: some View {
        ImportancePicker(selectedSegment: $todoItem.importance)
    }
    
    private var colorPicker: some View {
        ColorPicker("Цвет", selection: $selectedColor)
            .frame(height: 56)
            .onChange(of: selectedColor) {
                todoItem.hexColor = selectedColor.hexString
            }
    }
    
    private var deadlineToggleView: some View {
        HStack {
            VStack(alignment: .leading) {
                Text("Сделать до")
                if todoItem.isDeadlineEnabled {
                    Text(todoItem.deadline, style: .date)
                        .transition(.blurReplace)
                        .foregroundStyle(Color.blue)
                        .onTapGesture {
                            isDatePickerVisible.toggle()
                        }
                }
            }
            Toggle("", isOn: $todoItem.isDeadlineEnabled)
                .onChange(of: todoItem.isDeadlineEnabled) { _, newValue in
                    isDatePickerVisible = newValue
                }
        }
        .frame(height: 56)
    }
    
    @ViewBuilder
    private var datePicker: some View {
        if isDatePickerVisible, !isActive {
            DatePicker("", selection: $todoItem.deadline, displayedComponents: .date)
                .transition(.blurReplace) // FIXME: - not working ...
                .datePickerStyle(.graphical)
        }
    }
    
    private var toolbarButtonKeyboardView: some View {
        HStack {
            Image(systemName: "chevron.up")
            Divider()
            Image(systemName: "chevron.down")
            Divider()
            Spacer()
            Divider()
            Button("Готово") {
                isActive = false
            }
        }
    }
}
