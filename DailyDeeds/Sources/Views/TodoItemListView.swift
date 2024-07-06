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
    var viewModel: ListTodoItemViewModel
    
    @Environment(\.verticalSizeClass)
    private var verticalSizeClass
    @Environment(\.horizontalSizeClass)
    private var horizontalSizeClass
    
    @FocusState
    private var isActive: Bool
    @State
    private var selectedItem: TodoItem?
    @State
    private var interfaceOrientation: InterfaceOrientation = .unknown
    
    var body: some View {
        NavigationSplitView {
            todoItemsListView
                .overlay(alignment: !interfaceOrientation.deviceType.isSmall ? .bottomLeading : .bottom) {
                    if !isActive {
                        CreateTodoItemButton(action: createEmptyItem)
                            .padding(32)
                    }
                }
        } detail: {
            if let selectedItem = selectedItem, !interfaceOrientation.deviceType.isSmall {
                DetailTodoItemView(todoItem: selectedItem) { item in
                    viewModel.update(oldItem: selectedItem, to: item)
                    self.selectedItem = nil
                }
            } else if !interfaceOrientation.deviceType.isSmall {
                Text("Выберите задачу для просмотра деталей")
                    .foregroundStyle(Color.labelSecondary)
            }
        }
    }
    
    private var todoItemsListView: some View {
        listView
            .scrollContentBackground(Color.backPrimary)
            .scrollIndicators(.hidden)
            .navigationTitle("Мои дела")
            .sheet(isPresented: interfaceOrientation.deviceType.isSmall, item: $selectedItem) { item in
                DetailTodoItemView(todoItem: item) { newItem in
                    viewModel.update(oldItem: item, to: newItem)
                }
            }
            .onAppear {
                interfaceOrientation = InterfaceOrientation(
                    horizontal: horizontalSizeClass,
                    vertical: verticalSizeClass
                )
            }
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    sortingButton
                }
                ToolbarItem(placement: .topBarLeading) {
                    NavigationLink {
                        CalendarViewControllerRepresentable(model: viewModel.model)
                            .navigationTitle("Календарь")
                            .navigationBarTitleDisplayMode(.inline)
                            .ignoresSafeArea(edges: .bottom)
                            .toolbarBackground(.supportNavBarBlur, for: .navigationBar)
                            .toolbarBackground(.visible, for: .navigationBar)
                    } label: {
                        Image(systemName: "calendar")
                    }
                }
            }
    }
    
    @ViewBuilder
    private var listView: some View {
        switch interfaceOrientation.deviceType {
        case .small:
            List {
                listContent
            }
        case .large:
            List(selection: $selectedItem) {
                listContent
            }
            .listStyle(.sidebar)
        }
    }
    
    private var listContent: some View {
        Section {
            ForEach(viewModel.items) { item in
                listRow(for: item)
            }
            .onDelete(perform: viewModel.remove)
            .listRowInsets(.init(top: 16, leading: 16, bottom: 16, trailing: 0))
            
            CreateNewTodoItemRowView { text in
                viewModel.append(TodoItem(text: text))
            }
            .listRowInsets(.init())
            .focused($isActive)
        } header: {
            listHeaderView
        } footer: {
            Text(viewModel.sort.fullDescription)
                .foregroundStyle(Color.labelTertiary)
        }
    }
    
    private var listHeaderView: some View {
        HStack {
            Text("Выполнено – \(viewModel.completedTodoItemsCount)")
                .foregroundStyle(Color.labelTertiary)
            Spacer()
            Button {
                withAnimation {
                    viewModel.toggleFilter()
                }
            } label: {
                Text(viewModel.filter.isEnabled ? "Показать" : "Скрыть")
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
                .symbolEffect(.bounce.down, value: viewModel.sort)
        }
    }
    
    private func listRow(for item: TodoItem) -> some View {
        ListRowItemView(item: item)
            .swipeActions(edge: .leading, allowsFullSwipe: true) {
                Button {
                    viewModel.toggleCompletion(item)
                } label: {
                    Image(systemName: item.isDone ? "xmark.circle": "checkmark.circle")
                }
                .tint(Color.green)
            }
            .swipeActions(edge: .trailing, allowsFullSwipe: true) {
                Button(role: .destructive) {
                    viewModel.remove(with: item.id)
                } label: {
                    Image(systemName: "trash")
                }
                .tint(Color.red)
                Button {
                    print(viewModel.items)
                } label: {
                    Image(systemName: "info.circle")
                }
                .tint(Color.colorLightGray)
            }
        
            .onTapGesture {
                selectedItem = item
            }
    }
    
    private func createEmptyItem() {
        selectedItem = TodoItem(text: "")
    }
}
