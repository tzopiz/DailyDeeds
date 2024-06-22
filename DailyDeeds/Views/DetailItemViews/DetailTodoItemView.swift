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
}
