//
//  TodoItemView.swift
//  DailyDeeds
//
//  Created by Дмитрий Корчагин on 6/22/24.
//

import SwiftUI

struct DetailTodoItemView: View {
    // FIXME: - add buttons: save, create, cancel and sorting -
    // .contentTransition(.symbolEffect(.replace))
    let item: TodoItem
    
    @Environment(\.dismiss)
    fileprivate var dismiss
    
    @State
    var selectedState = 0
    @State
    var selectedDate = Date()
    @State
    var isOn: Bool
    @State
    var text: String
    
    init(item: TodoItem) {
        self.item = item
        self.isOn = item.deadline != nil
        self.text = item.text
    }
    
    var body: some View {
        
        // FIXME: - navigation stack? -
        NavigationStack {
            Form {
                Section {
                    TextEditorView(text: text)
                }
                Section {
                    HStack {
                        Text("Важность")
                        Spacer()
                        ImportancePicker(selectedSegment: selectedState)
                    }
                    .padding(4)
                    
                    deadlineSectionView
                        .padding(4)
                    
                    if let deadline = item.deadline {
                        DataPickerView(deadline: deadline)
                    }                }
            }
            .navigationTitle("Дело")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button("Отменить") {
                        dismiss()
                    }
                }
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Сохранить") {
                        dismiss()
                    }
                }
            }
            .background(Res.Color.Back.iOSPrimary)
        }
    }
    
    fileprivate var deadlineSectionView: some View {
        HStack {
            VStack(alignment: .leading) {
                Text("Сделать до")
                if let deadline = item.deadline {
                    Button(deadline.toString(format: "dd MMMM")) {
                        print(#function)
                    }
                }
            }
            Toggle("", isOn: $isOn)
        }
    }
}

#Preview {
    let item = TodoItemViewModel.createTodoItems(5).randomElement()!
    DetailTodoItemView(item: item)
}
