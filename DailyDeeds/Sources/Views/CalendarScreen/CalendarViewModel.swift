//
//  CalendarViewModel.swift
//  DailyDeeds
//
//  Created by Дмитрий Корчагин on 6/30/24.
//

import UIKit
import UIComponents

protocol ICalendarViewModel: ICollectionViewModel {
    func row(for indexPath: IndexPath) -> TodoItem
    func header(for indexPath: IndexPath) -> String
}

final class CalendarViewModel: ICalendarViewModel {
    struct Section<ItemType> {
        let date: Date
        var items: [ItemType]
    }
    
    var items: [Section<TodoItem>]
    var title: String?
    var navigationDelegate: ViewModelNavigationDelegate?
    
    init(todoItems: [TodoItem]) {
        self.items = CalendarViewModel.groupTodoItemsByDate(todoItems)
        self.title = "Мои дела"
    }
    
    func item(for indexPath: IndexPath) -> Section<TodoItem> {
        return items[indexPath.section]
    }
    
    func row(for indexPath: IndexPath) -> TodoItem {
        return item(for: indexPath).items[indexPath.row]
    }
    
    func header(for indexPath: IndexPath) -> String {
        return items[indexPath.section].date.toString()
    }
    
    private static func groupTodoItemsByDate(_ items: [TodoItem]) -> [Section<TodoItem>] {
        let groupedDictionary = Dictionary(grouping: items) {
            $0.creationDate.strip(to: .days)
        }
        let sections = groupedDictionary.map {
            Section(date: $0.key, items: $0.value)
        }
        return sections.sorted { $0.date < $1.date }
    }
}
