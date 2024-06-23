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
<<<<<<< HEAD
    let item: TodoItem
    @State 
    private var selectedState = 0
    @State 
    private var selectedDate = Date()
    @State 
    private var isOn = false
    @State 
    private var text = ""
    
    let states = [
        Label("", systemImage: "swift"),
        Label("", systemImage: "swift"),
        Label("", systemImage: "swift")
    ]
    init(for item: TodoItem) {
        self.item = item
    }
    var body: some View {
        Form {
            Section {
                // FIXME: - scale to show all content inside -
                TextEditor(text: $text)
                    .padding(EdgeInsets(top: -8, leading: -8, bottom: -8, trailing: -8))
                    .font(.system(size: 16))
                    .frame(height: 200)
            }
            Section {
                HStack {
                    // FIXME: - show label berfore picker -
                    Text("Importance")
                    Spacer()
                    Picker(.init(""), selection: $selectedState) {
                        ForEach(0..<3) { index in
                            self.states[index].tag(index)
                        }
                    }
                    .scaledToFit()
                    .pickerStyle(SegmentedPickerStyle())
                    .padding(4)
                }
                Toggle(isOn: $isOn) { Text("Deadline") }
                    .padding(4)
                if isOn {
                    // FIXME: - default deadline tommorow -
                    DatePicker(
                        .init(""),
                        selection: $selectedDate,
                        in: Date()...,
                        displayedComponents: .date
                    )
                    // FIXME: - add animation -
                    .datePickerStyle(.graphical)
                }
            }
        }
    }
=======
    
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
>>>>>>> ui-implementation
}
