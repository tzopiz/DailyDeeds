//
//  TodoItemView.swift
//  DailyDeeds
//
//  Created by Дмитрий Корчагин on 6/22/24.
//

import SwiftUI

struct DetailTodoItemView: View {
    // FIXME: -
    // - [ ] animation sorting: contentTransition(.symbolEffect(.replace))
    // - [ ] navigation stack?
    // - [ ] hide keyboard after stop typing
    // - [ ] dynamic hight textview
    let item: TodoItem
    
    @Environment(\.dismiss)
    private var dismiss
    
    @State
    private var selectedState: Int
    @State
    private var selectedDate = Date()
    @State
    private var isOn: Bool
    @State
    private var text: String
    
    init(item: TodoItem) {
        self.item = item
        self.isOn = item.deadline != nil
        self.text = item.text
        self.selectedState = item.importance.order
    }
    
    var body: some View {
        NavigationStack {
            Form {
                Section {
                    TextEditorView(text: text)
                        .frame(height: 120)
                }
                
                Section {
                    importanceView
                    DeadlineView(
                        manager: DeadlineManager(deadline: item.deadline)
                    )
                }
                
                Section {
                    deleteButton
                }
            }
            .listSectionSpacing(16)
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
        }
    }
    
    private var importanceView: some View {
        HStack {
            Text("Важность")
                .font(.system(size: 19))
            Spacer()
            ImportancePicker(selectedSegment: selectedState)
        }
        .padding(4)
    }
    
    private var deleteButton: some View {
        Button {
            print("button delete pressed")
        } label: {
            HStack {
                Spacer()
                Text("Удалить")
                    .tint(Color.red)
                    .font(.system(size: 19))
                Spacer()
            }
        }
    }
}

#Preview {
    let item = TodoItemViewModel.createTodoItems(5).randomElement()!
    DetailTodoItemView(item: item)
}
