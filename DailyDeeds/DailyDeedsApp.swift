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
    private let items = TodoItemViewModel.createTodoItems(100)
    
    var body: some Scene {
        WindowGroup {
            TodoItemsListView(viewModel: TodoItemViewModel(items: items))
        }
    }
}
