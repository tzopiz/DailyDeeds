//
//  DailyDeedsApp.swift
//  DailyDeeds
//
//  Created by Дмитрий Корчагин on 6/14/24.
//

import SwiftUI

@main
struct DailyDeedsApp: App {
    private let items = TodoItemViewModel.createTodoItems(4)
    
    var body: some Scene {
        WindowGroup {
            TodoItemsListView(viewModel: TodoItemViewModel(items: items))
        }
    }
}
