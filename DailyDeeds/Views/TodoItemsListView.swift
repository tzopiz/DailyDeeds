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
    // TODO: -
    // - [ ] ObservedObject -> Observable
    // - [ ] combine
    // - [x] last line such as button to add new item
    @ObservedObject
    var viewModel: TodoItemViewModel
    
    @Namespace
    private var sorting
    
    @Environment(\.dismiss)
    private var dismiss
    
    @FocusState
    private var isActive: Bool
    
    @State
    private var selectedItem: TodoItem?
    
    @State
    private var onEnded = false
    
    var body: some View {
        NavigationStack {
            ZStack(alignment: .bottom) {
                todoItemsList
                if !isActive {
                    CreateTodoItemButton(action: addNewItem)
                }
            }
        }
    }
    
    private var todoItemsList: some View {
        List {
            Section {
                ForEach(viewModel.items) { item in
                    listRow(for: item)
                }
                .onMove(perform: viewModel.move)
                .onDelete(perform: viewModel.remove)
                CreateNewTodoItemRowView(text: "")
                    .focused($isActive)
            } header: {
                listHeaderView
            } footer: {
                Text(viewModel.sortType.fullDescription)
            }
            Section {
                Color.clear
                    .frame(height: 200)
            }
            .listRowBackground(Color.clear)
        }
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
    
    private var listHeaderView: some View {
        HStack {
            Text("Выполнено – \(viewModel.completeTodoItemsCount)")
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
        let sortingOptions: [SortType] = [
            .byCreationDate(),
            .byDeadline(),
            .byLastModifiedDate(),
            .byImportance(),
            .byCompletionStatus()
        ]
        let orderOptions: [SortType.Order] = [
            .ascending,
            .descending
        ]
        return Menu {
            ForEach(sortingOptions, id: \.self) { option in
                Menu(option.shortDescription) {
                    ForEach(orderOptions, id: \.self) { order in
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
        CustomContextMenu {
            ListItemView(item: item)
        } preview: {
            previewTodoItem(for: item)
        } actoions: {
            let copyAction = UIAction(
                title: "Copy",
                image: UIImage(systemName: "doc.on.doc")
            ) { action in
                UIPasteboard.general.string = item.description
            }
            let shareAction = UIAction(
                title: "Share",
                image: UIImage(systemName: "square.and.arrow.up")
            ) { action in
                print("share")
            }
            return UIMenu(title: "Меню", children: [copyAction, shareAction])
        } onEnd: {
            withAnimation {
                onEnded.toggle()
            }
        }
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
        .onTapGesture {
            selectedItem = item
        }
    }
    
    private func previewTodoItem(for item: TodoItem) -> some View {
        VStack(alignment: .leading) {
            Text("TodoItem")
            Divider()
            Text("id: \(item.id)")
            Divider()
            Text("text: \(item.text)")
            Divider()
            HStack {
                Text("isDone: \(item.isDone)")
                CheckmarkView(
                    isDone: item.isDone,
                    importance: item.importance
                )
            }
            Divider()
            HStack {
                Text("importance: \(item.importance)")
                ImportanceView(importance: item.importance)
            }
            Divider()
            HStack {
                Text("hexColor: \(item.hexColor)")
                Color(hex: item.hexColor)
                    .frame(width: 90, height: 30)
                    .border(Res.Color.Label.primary, width: 2)
            }
            Divider()
            Text("createdDate: \(item.creationDate)")
            Divider()
            Text("deadline: \(item.deadline.toString())")
            Divider()
            Text("modificationDate: \(item.modificationDate.toString())")
        }
        .font(.system(size: 21))
        .font(.headline)
        .padding(16)
        .overlay(alignment: .topTrailing) {
            Image(systemName: "xmark")
                .resizable()
                .foregroundStyle(Color.secondary)
                .frame(width: 25, height: 25)
                .padding(8)
        }
    }
    
    private func addNewItem() {
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
