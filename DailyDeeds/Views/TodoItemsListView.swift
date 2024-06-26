//
//  TodoItemsListView.swift
//  DailyDeeds
//
//  Created by Дмитрий Корчагин on 6/22/24.
//

import SwiftUI

struct TodoItemsListView: View {
    // TODO: -
    // - [ ] ObservedObject -> Observable
    // - [ ] combine
    // - [ ] last line such as button to add new item
    @ObservedObject
    var viewModel: TodoItemViewModel
    
    @Namespace
    private var sorting
    
    @Environment(\.dismiss)
    private var dismiss
    
    @State
    private var selectedItem: TodoItem?
    
    private let sortingOptions: [SortType] = [
        .byCreationDate(),
        .byDeadline(),
        .byDateModified(),
        .byImportance(),
        .byIsDone()
    ]
    
    private let orderOptions: [SortType.Order] = [
        .ascending,
        .descending
    ]
    
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
            
            Section {
                Text(viewModel.sortType.fullDescription)
                    .foregroundStyle(Res.Color.Label.tertiary)
                    .listRowBackground(Res.Color.Back.iOSPrimary)
            }
        }
        .listSectionSpacing(0)
        .scrollIndicators(.hidden)
        .navigationTitle("Мои дела")
        .sheet(item: $selectedItem) { item in
            DetailTodoItemView(item: item)
        }
        .toolbar {
            sortingButton
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
    
    private var sortingButton: some View {
        Menu {
            ForEach(sortingOptions, id: \.self) { option in
                Menu(option.shortDescription) {
                    ForEach(orderOptions, id: \.self) { order in
                        let sortType = SortType(option, order: order)
                        Button {
                            viewModel.setSortType(sortType)
                        } label: {
                            Text(sortType.description)
                        }
                    }
                }
            }
            Button {
                viewModel.setSortType(.none)
            } label: {
                Text(SortType.none.shortDescription)
            }
        } label: {
            Image(
                systemName: viewModel.sortType == .none ? "line.3.horizontal.decrease.circle" : "line.3.horizontal.decrease.circle.fill"
            )
            .symbolEffect(.bounce.down, value: viewModel.sortType)
        }
    }
    
    private var listHeaderView: some View {
        HStack {
            Text("Выполнено – \(viewModel.completeTodoItemsCount)")
                .foregroundStyle(Res.Color.Label.tertiary)
            Spacer()
            Button {
                withAnimation {
                    viewModel.setSortType(
                        viewModel.sortType == .isDoneOnly(.ascending) ? .isDoneOnly(.descending) : .isDoneOnly(.ascending)
                    )
                }
            } label: {
                Text(
                    viewModel.sortType == .isDoneOnly(.ascending) ? "Скрыть" : "Показать"
                )
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
