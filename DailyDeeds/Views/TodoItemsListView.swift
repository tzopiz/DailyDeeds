//
//  TodoItemsListView.swift
//  DailyDeeds
//
//  Created by Дмитрий Корчагин on 6/22/24.
//

import SwiftUI

struct TodoItemsListView: View {
    @ObservedObject
    var viewModel: TodoItemViewModel
    
    @Namespace
    var sorting
    
    @Environment(\.dismiss)
    var dismiss
    
    @State
    var selectedItem: TodoItem?
    
    var body: some View {
        NavigationStack {
            ZStack(alignment: .bottom) {
                todoItemsList
                CreateTodoItemButton(action: addNewItem)
            }
        }
    }

     var todoItemsList: some View {
        List {
            ForEach(viewModel.items) { item in
                ListItemView(item: item)
                    .swipeActions(edge: .leading, allowsFullSwipe: true) {
                        Button { print("complete button tapped") }
                        label: { Image(systemName: "checkmark.circle") }
                    }
                    .tint(Res.Color.green)
                
                    .swipeActions(edge: .trailing, allowsFullSwipe: true) {
                        Button { print("delete button tapped") }
                        label: { Image(systemName: "trash") }
                    }
                    .tint(Res.Color.red)
                
                    .swipeActions(edge: .trailing, allowsFullSwipe: true) {
                        Button { print("info button tapped") }
                        label: { Image(systemName: "info.circle") }
                    }
                    .tint(Res.Color.gray)
                    .gesture(
                        TapGesture().onEnded { a in
                            selectedItem = item
                        }
                    )
            }
            .onMove(perform: viewModel.move)
        }
        .navigationTitle("Мои дела")
        .sheet(item: $selectedItem) { item in
            DetailTodoItemView(item: item)
        }
        .toolbar {
            Button { print(#function) }
            label: {
                Image(systemName: "line.3.horizontal.decrease.circle")
            }
            EditButton()
        }
    }
    func addNewItem() {
        guard let newItem = TodoItemViewModel.createTodoItems(5).randomElement() 
        else { return }
        viewModel.append(newItem)
    }
}

#Preview {
    let items = TodoItemViewModel.createTodoItems(10)
    TodoItemsListView(
        viewModel: TodoItemViewModel(items: items)
    )
}
