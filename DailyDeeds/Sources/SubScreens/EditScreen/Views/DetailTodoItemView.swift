//
//  TodoItemView.swift
//  DailyDeeds
//
//  Created by Дмитрий Корчагин on 6/22/24.
//

import SwiftUI

struct DetailTodoItemView: View {

    @ObservedObject
    var todoItem: MutableTodoItem
    var onUpdate: (TodoItem?) -> Void

    @Environment(\.dismiss)
    private var dismiss
    @Environment(\.verticalSizeClass)
    private var verticalSizeClass
    private let initialTodoItem: TodoItem

    init(todoItem: TodoItem, onUpdate: @escaping (TodoItem?) -> Void) {
        self.todoItem = todoItem.mutable
        self.onUpdate = onUpdate
        self.initialTodoItem = todoItem
    }

    var body: some View {
        NavigationStack {
            content
                .navigationTitle("Дело")
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    ToolbarItem(placement: .topBarLeading) {
                        Button("Отменить") {
                            onUpdate(initialTodoItem)
                            dismiss()
                        }
                    }
                    ToolbarItem(placement: .topBarTrailing) {
                        Button("Сохранить") {
                            onUpdate(todoItem.immutable)
                            dismiss()
                        }
                        .disabled(todoItem.text.isEmpty)
                    }
                }
        }
    }

    @ViewBuilder
    private var content: some View {
        if verticalSizeClass == .compact {
            compactVerticalDetailView
        } else if verticalSizeClass == .regular {
            regularVerticalDetailView
        }
    }

    private var regularVerticalDetailView: some View {
        RegularVerticalDetailView(todoItem: todoItem) {
            deleteButton
        }
    }

    private var compactVerticalDetailView: some View {
        CompactVerticalDetailView(todoItem: todoItem) {
            deleteButton
        }
    }

    private var deleteButton: some View {
        Button(role: .destructive) {
            onUpdate(nil)
            dismiss()
        } label: {
            Text("Удалить")
                .frame(maxWidth: .infinity)
                .frame(height: 56)
        }
    }
}
