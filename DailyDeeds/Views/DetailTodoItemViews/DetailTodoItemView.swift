//
//  TodoItemView.swift
//  DailyDeeds
//
//  Created by Дмитрий Корчагин on 6/22/24.
//

import SwiftUI

struct DetailTodoItemView: View {
    // TODO: -
    // - [ ] scroll textview in .compact mode
    // - [ ] button delete and save
    let item: TodoItem
    
    @Environment(\.dismiss)
    private var dismiss
    @Environment(\.horizontalSizeClass)
    private var horizontalSizeClass
    
    private enum TextEditorFocus: Int {
        case text
    }
    
    @FocusState
    private var textEditorFocus: TextEditorFocus?
    
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
            content
                .listSectionSpacing(16)
                .scrollIndicators(.hidden)
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
    
    @ViewBuilder
    private var content: some View {
        if horizontalSizeClass == .compact {
            compactView
        } else if horizontalSizeClass == .regular {
            regularView
        }
    }

    private var regularView: some View {
        // FIXME: - -16?(WTF) -
        HStack(alignment: .top, spacing: -16) {
            GeometryReader { geometry in
                Form {
                    ScrollView {
                        TextEditor(text: $text)
                            .frame(height: geometry.size.height - 80)
                            .focused($textEditorFocus, equals: .text)
                    }
                }
            }
            .scrollDisabled(true)
            Form {
                baseFormItems()
            }
        }
        .background(Res.Color.Back.iOSPrimary)
    }
    
    private var compactView: some View {
        Form {
            Section {
                TextEditor(text: $text)
                    .frame(minHeight: 120)
                    .fixedSize(horizontal: false, vertical: true)
                    .focused($textEditorFocus, equals: .text)
            }
            baseFormItems()
        }
        .toolbar {
            ToolbarItem(placement: .keyboard) {
                HStack {
                    Button {
                        textEditorFocus = nil
                    } label: {
                        Text("Close")
                    }
                    Divider()
                    Spacer()
                }
            }
        }
    }
    
    @ViewBuilder
    private func baseFormItems() -> some View {
        Section {
            importanceView
                .padding(4)
            DeadlineView(
                manager: DeadlineManager(deadline: item.deadline)
            )
            .padding(4)
        }
        Section {
            deleteButton
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
        Button { }
        label: {
            HStack {
                Spacer()
                Text("Удалить")
                    .tint(Res.Color.red)
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
