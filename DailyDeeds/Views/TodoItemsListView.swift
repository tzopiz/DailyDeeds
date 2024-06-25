//
//  TodoItemsListView.swift
//  DailyDeeds
//
//  Created by Дмитрий Корчагин on 6/22/24.
//

import SwiftUI

struct TodoItemsListView: View {
    // FIXME: -
    // - [ ] animation sorting: contentTransition(.symbolEffect(.replace))
    // - [ ] ObservedObject -> Observable
    // - [ ] different orientation
    @ObservedObject
    var viewModel: TodoItemViewModel
    
    @Namespace
    private var sorting
    
    @Environment(\.dismiss)
    private var dismiss
    
    @State
    private var selectedItem: TodoItem?
    
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
            Section() {
                listHeaderView
                .listRowBackground(Res.Color.Back.iOSPrimary)
            }
            
            ForEach(viewModel.items) { item in
                listRow(for: item)
            }
            .onMove(perform: viewModel.move)
            .onDelete(perform: viewModel.remove)
        }
        .listSectionSpacing(0)
        .scrollIndicators(.hidden)
        .navigationTitle("Мои дела")
        .sheet(item: $selectedItem) { item in
            DetailTodoItemView(item: item)
        }
        .toolbar {
            Button { print("sorted button pressed") }
            label: {
                Image(systemName: "line.3.horizontal.decrease.circle")
            }
            EditButton()
        }
    }
    
    func listRow(for item: TodoItem) -> some View {
        ListItemView(item: item)
            .swipeActions(edge: .leading, allowsFullSwipe: true) {
                Button {
                    print("complete button tapped")
                }
                label: {
                    Image(systemName: "checkmark.circle")
                }
            }
            .tint(Res.Color.green)
        
            .swipeActions(edge: .trailing, allowsFullSwipe: true) {
                Button(role: .destructive) {
                    viewModel.remove(with: item.id)
                } label: {
                    Image(systemName: "trash")
                }
            }
            .tint(Res.Color.red)
        
            .swipeActions(edge: .trailing) {
                Button {
                    print(item.description)
                }
                label: {
                    Image(systemName: "info.circle")
                }
            }
            .tint(Res.Color.gray)
            .gesture(
                TapGesture().onEnded { a in
                    selectedItem = item
                }
            )
    }
    
    private var listHeaderView: some View {
        HStack {
            Text("Выполнено – 5")
                .foregroundStyle(Res.Color.Label.tertiary)
            Spacer()
            Button {
                print("Показать выполненые задачи")
            } label: {
                Text("Показать")
            }
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
