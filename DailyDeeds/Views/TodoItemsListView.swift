//
//  TodoItemsListView.swift
//  DailyDeeds
//
//  Created by Дмитрий Корчагин on 6/22/24.
//

import SwiftUI

struct TodoItemsListView: View {
    typealias SortType = TaskCriteria.SortType
    typealias FilterType = TaskCriteria.FilterType
    
    @ObservedObject
    var viewModel: TodoItemViewModel
    
    @Environment(\.dismiss)
    private var dismiss
    @Environment(\.verticalSizeClass)
    private var verticalSizeClass
    @Environment(\.horizontalSizeClass)
    private var horizontalSizeClass
    
    @FocusState
    private var isActive: Bool
    
    @State
    private var selectedItem: TodoItem?
    @State
    private var isSideBarList: Bool = true
    
    var body: some View {
        NavigationSplitView {
            todoItemsListView
                .overlay(alignment: isSideBarList ? .bottomLeading : .bottom) {
                    if !isActive {
                        CreateTodoItemButton(action: addNewItem)
                            .padding(32)
                    }
                }
        } detail: {
            if let selectedItem = selectedItem, isSideBarList {
                DetailTodoItemView(todoItem: selectedItem.mutable) { item in
                    viewModel.update(oldItem: selectedItem, to: item)
                    self.selectedItem = nil
                }
            } else if isSideBarList {
                Text("Выберите задачу для просмотра деталей")
                    .foregroundStyle(Res.Color.Label.secondary)
            }
        }
    }
    
    @ViewBuilder
    private var listView: some View {
        if isSideBarList {
            List(selection: $selectedItem) {
                listContent
            }
            .listStyle(.sidebar)
        } else {
            List {
                listContent
            }
        }
    }

    private var todoItemsListView: some View {
        listView
        .scrollContentBackground(.hidden)
        .background(Res.Color.Back.iOSPrimary)
        .scrollIndicators(.hidden)
        .navigationTitle("Мои дела")
        .customSheet(isPresented: !isSideBarList, item: $selectedItem) { item in
            DetailTodoItemView(todoItem: item.mutable) { newItem in
                viewModel.update(oldItem: item, to: newItem)
            }
        }
        .toolbar {
            sortingButton
        }
        .onAppear {
            isSideBarList = horizontalSizeClass == .regular && verticalSizeClass == .regular
        }
    }
    
    private var listContent: some View {
        Section {
            ForEach(viewModel.items) { item in
                listRow(for: item)
            }
            .onDelete(perform: viewModel.remove)
            
            CreateNewTodoItemRowView(text: "") { text in
                viewModel.append(TodoItem(text: text))
            }
            .focused($isActive)
        } header: {
            listHeaderView
        } footer: {
            Text(viewModel.sortType.fullDescription)
                .foregroundStyle(Res.Color.Label.tertiary)
        }
        .listRowBackground(Res.Color.Back.secondary)
        .listRowInsets(.init(top: 0, leading: 8, bottom: 0, trailing: 8))
        .listRowSeparatorTint(Res.Color.Support.separator)
    }
    
    private var listHeaderView: some View {
        HStack {
            Text("Выполнено – \(viewModel.completedTodoItemsCount)")
                .foregroundStyle(Res.Color.Label.tertiary)
            Spacer()
            Button {
                withAnimation {
                    viewModel.toggleFilter()
                }
            } label: {
                Text(viewModel.filterType == .all ? "Скрыть" : "Показать")
            }
        }
    }
    
    private var sortingButton: some View {
        Menu {
            ForEach(SortType.allCases, id: \.self) { option in
                Menu(option.shortDescription) {
                    ForEach(SortType.Order.allCases, id: \.self) { order in
                        let sortType = SortType(option, order: order)
                        Button {
                            withAnimation {
                                viewModel.setSortType(sortType)
                            }
                        } label: {
                            Text(sortType.description)
                        }
                    }
                }
            }
        } label: {
            Image(systemName: "line.3.horizontal.decrease.circle")
                .symbolEffect(.bounce.down, value: viewModel.sortType)
        }
    }
    
    private func listRow(for item: TodoItem) -> some View {
        ListRowItemView(item: item)
            .listRowInsets(.init(top: 16, leading: 16, bottom: 16, trailing: 0))
            .swipeActions(edge: .leading, allowsFullSwipe: true) {
                Button {
                    viewModel.complete(item)
                } label: {
                    Image(systemName: item.isDone ? "xmark.circle": "checkmark.circle")
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
            .swipeActions(edge: .trailing, allowsFullSwipe: true) {
                Button {
                    print(viewModel.items)
                } label: {
                    Image(systemName: "info.circle")
                }
            }
            .tint(Res.Color.lightGray)
            .onTapGesture {
                selectedItem = item
            }
    }
    
    private func addNewItem() {
        selectedItem = TodoItem(text: "")
    }
}

#Preview {
    let items = TodoItemViewModel.createTodoItems(10)
    TodoItemsListView(
        viewModel: TodoItemViewModel(items: items)
    )
}
