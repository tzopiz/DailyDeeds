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
    private var selectedState: Int
    @State
    private var isDatePickerVisible: Bool = false
    @State
    private var textEditorHeight: CGFloat = 40
    @State
    private var isShowingColorPicker = false
    
    init(todoItem: MutableTodoItem, @ViewBuilder content: () -> Content) {
        self.content = content()
        self.todoItem = todoItem
        self.selectedColor = Color(hex: todoItem.hexColor)
        self.selectedState = todoItem.importance.order
    }
    
    var body: some View {
        Form {
            Section {
                TextField("Что мне сдеать?", text: $todoItem.text, axis: .vertical)
                    .frame(minHeight: 120, alignment: .topLeading)
                    .padding(.all, 12)
                    .focused($isActive)
            }
            .listRowBackground(Res.Color.Back.secondary)
            .listRowInsets(.init())
            
            Section {
                importanceView
                colorPicker
                deadlineToggleView
                if isDatePickerVisible, !isActive {
                    datePicker
                }
            }
            .listRowBackground(Res.Color.Back.secondary)
            .listRowInsets(.init(top: 0, leading: 16, bottom: 0, trailing: 16))
            
            Section {
                content
            }
            .listRowBackground(Res.Color.Back.secondary)
            .listRowInsets(.init(top: 0, leading: 16, bottom: 0, trailing: 16))
        }
        /* FIXME: smth blinking other views
         .animation(.easeInOut, value: isDatePickerVisible)
         .animation(.easeInOut, value: todoItem.isDeadlineEnabled)
         */
        .scrollIndicators(.hidden)
        .listSectionSpacing(16)
        .scrollContentBackground(.hidden)
        .background(Res.Color.Back.primary)
        .contentMargins(.all, 16)
        .toolbar {
            ToolbarItem(placement: .keyboard) {
                toolbarButtonKeyboardView
            }
        }
    }
    
    private var importanceView: some View {
        ImportancePicker(selectedSegment: $selectedState)
            .onChange(of: selectedState) {
                todoItem.importance = Importance(selectedState)
            }
    }
    
    private var colorPicker: some View {
        HStack {
            VStack(alignment: .leading, spacing: 2) {
                Text("Цвет")
                Text(selectedColor.hexString)
                    .font(.system(size: 14))
                    .foregroundStyle(Res.Color.Label.primary)
                    .padding(2)
                    .background(Res.Color.lightGray)
                    .clipShape(.rect(cornerRadius: 4))
            }
            Spacer()
            Button {
                isShowingColorPicker.toggle()
            } label: {
                gradientButtonView
            }
            
        }
        .frame(height: 56)
        .sheet(isPresented: $isShowingColorPicker, onDismiss: {
            todoItem.hexColor = selectedColor.hexString
        }, content: {
            CustomColorPicker(selectedColor: $selectedColor)
                .presentationDetents([.height(600)])
        })
    }
    
    private var gradientButtonView: some View {
        ZStack {
            ColorGradientCircleView()
            Circle()
                .fill(selectedColor)
                .overlay(
                    Circle()
                        .strokeBorder(
                            Res.Color.Back.secondary,
                            lineWidth: 2
                        )
                )
                .frame(width: 32, height: 32)
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
                            withAnimation {
                                isDatePickerVisible.toggle()
                            }
                        }
                }
            }
            Toggle("", isOn: $todoItem.isDeadlineEnabled.animation())
                .onChange(of: todoItem.isDeadlineEnabled) { _, newValue in
                    withAnimation {
                        isDatePickerVisible = newValue
                    }
                }
        }
        .frame(height: 56)
    }
    
    private var datePicker: some View {
        DatePicker("", selection: $todoItem.deadline, displayedComponents: .date)
            .transition(.scale)
            .datePickerStyle(.graphical)
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
        .padding(4)
    }
}
