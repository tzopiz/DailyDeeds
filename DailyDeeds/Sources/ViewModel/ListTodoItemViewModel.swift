//
//  TodoItemViewModel.swift
//  DailyDeeds
//
//  Created by Дмитрий Корчагин on 6/23/24.
//

import CocoaLumberjackSwift
import Combine
import SwiftUI

protocol IListTodoItemViewModel: IBaseTodoItemViewModel {
    var completedTodoItemsCount: Int { get }
    var sort: TaskCriteria.SortType { get set }
    var filter: TaskCriteria.FilterType { get set }
    func setSortType(_ sortType: TaskCriteria.SortType)
    func toggleFilter()
}

final class ListTodoItemViewModel: ObservableObject, IListTodoItemViewModel {
    @Published
    var model: TodoItemModel
    
    @Published
    var sort: TaskCriteria.SortType = .byCreationDate(.descending)
    
    @Published
    var filter: TaskCriteria.FilterType = .all
    
    private var cancellables = Set<AnyCancellable>()
    
    var revision: Int {
        model.revision
    }
    
    var isDirty: Bool {
        model.isDirty
    }
    
    var completedTodoItemsCount: Int {
        model.items.filter(by: \.isDone, predicate: { $0 }).count
    }
    
    var items: [TodoItem] {
        let items: [TodoItem]
        switch filter {
        case .notCompletedOnly:
            items = model.items.filter(by: \.isDone, predicate: { !$0 })
        case .all:
            items = model.items
        }
        switch sort {
        case .byCreationDate(let order):
            return items.sorted(by: \.creationDate, ascending: order.isAscending)
        case .byDeadline(let order):
            return items.sorted(by: \.deadline, ascending: order.isAscending)
        case .byLastModifiedDate(let order):
            return items.sorted(by: \.modificationDate, ascending: order.isAscending)
        case .byImportance(let order):
            return items.sorted(by: \.importance, ascending: order.isAscending)
        case .byCompletionStatus(let order):
            return items.sorted(by: \.isDone, ascending: order.isAscending)
        }
    }

    init(model: TodoItemModel) {
        self.model = model
        setupBindings()
    }

    func remove(at offsets: IndexSet) {
        model.remove(at: offsets)
    }

    func move(fromOffsets indices: IndexSet, toOffset newOffset: Int) {
        model.move(fromOffsets: indices, toOffset: newOffset)
    }

    func setSortType(_ sortType: TaskCriteria.SortType) {
        self.sort = sortType
    }

    func toggleFilter() {
        switch filter {
        case .notCompletedOnly:
            filter = .all
        case .all:
            filter = .notCompletedOnly
        }
    }

    private func setupBindings() {
        model.objectWillChange.sink { [weak self] in
            self?.objectWillChange.send()
        }
        .store(in: &cancellables)
    }
}

// MARK: - Networking
extension ListTodoItemViewModel {
    @MainActor
    func fetchTodoList() {
        model.fetchTodoList()
    }
    
    @MainActor
    func fetchTodoItem(with id: String) {
        model.fetchTodoItem(with: id)
    }
    
    @MainActor
    func updateTodoItem(with id: String, item: TodoItem?) {
        guard let item = item else {
            deleteTodoItem(with: id)
            return
        }
        if model.containsItem(with: id) {
            model.updateTodoItem(with: id, item: item)
        } else {
            model.createTodoItem(with: id, item: item)
        }
    }
    
    @MainActor
    func updateTodoList() {
        model.updateTodoList()
    }
    
    @MainActor
    func createTodoItem(with id: String, item: TodoItem) {
        guard !item.text.isEmpty else { return }
        model.createTodoItem(with: id, item: item)
    }
    
    @MainActor
    func deleteTodoItem(with id: String) {
        model.deleteTodoItem(with: id, revision: revision)
    }
}
