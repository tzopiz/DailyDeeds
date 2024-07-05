//
//  DailyDeedsApp.swift
//  DailyDeeds
//
//  Created by Дмитрий Корчагин on 6/14/24.
//

import SwiftUI
import SnapKit

@main
struct DailyDeedsApp: App {
    private let model = TodoItemModel(
        items: ListTodoItemViewModel.createTodoItems(30)
    )
    var body: some Scene {
        WindowGroup {
            TodoItemsListView(viewModel: ListTodoItemViewModel(model: model))
        }
    }
}
