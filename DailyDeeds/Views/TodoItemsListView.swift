//
//  TodoItemsListView.swift
//  DailyDeeds
//
//  Created by Дмитрий Корчагин on 6/22/24.
//

import SwiftUI

struct TodoItemsListView: View {
    @ObservedObject
<<<<<<< HEAD
    private var viewModel = TodoListViewModel()
    
    @State
    private var isSorted = false
    
    var body: some View {
        NavigationView {
            ZStack(alignment: .bottom) {
                todoItemsList
                addNewItemButton
            }
        }
    }
    
    private var todoItemsList: some View {
        List {
            ForEach(viewModel.fileCache.todoItems) { item in
                NavigationLink { DetailTodoItemView(for: item) }
                label: { todoItemListView(for: item) }
            }
            .onDelete(perform: viewModel.removeItem)
            .onMove(perform: viewModel.move)
        }
        .navigationTitle("Мои дела")
        .navigationBarItems(trailing: EditButton())
        .toolbar {
            Button { isSorted.toggle() }
            label: { Image(systemName: "line.3.horizontal.decrease.circle") }
                .symbolEffect(.bounce.down, value: isSorted)
        }
    }
    
    private var addNewItemButton: some View {
        Button(action: addNewItem) {
            Image(systemName: "plus.circle.fill")
                .resizable()
                .background(Color.white)
                .clipShape(Circle())
                .frame(width: 44, height: 44)
        }
        .shadow(radius: 7, x: 0, y: 5)
    }
    
    private func addNewItem() {
        let newItem = TodoItem(
            text: "Новая задача \(viewModel.fileCache.todoItems.count)",
            isDone: Bool.random(),
            importance: Bool.random() ? .medium : .high
        )
        viewModel.addItem(newItem)
    }
    
    private func todoItemListView(for item: TodoItem) -> some View {
        TodoItemView(item: item)
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
=======
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
>>>>>>> ui-implementation
    }
}

#Preview {
<<<<<<< HEAD
    TodoItemsListView()
=======
    let items = TodoItemViewModel.createTodoItems(10)
    TodoItemsListView(
        viewModel: TodoItemViewModel(items: items)
    )
>>>>>>> ui-implementation
}
