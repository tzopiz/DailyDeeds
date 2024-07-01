//
//  CalendarViewModel.swift
//  DailyDeeds
//
//  Created by Дмитрий Корчагин on 6/30/24.
//

import UIKit
import UIComponents

struct DateInfo {
    let date: Date
    let isSelected: Bool
    var day: String {
        date.toString(format: "dd")
    }
    var month: String {
        date.toString(format: "MMM")
    }
    var year: String {
        date.toString(format: "YYYY")
    }
}

protocol ICalendarViewModel: ICollectionViewModel {
    func tableViewRow(for indexPath: IndexPath) -> TodoItem
    func collectionViewRow(for indexPath: IndexPath) -> DateInfo
    func tableViewHeader(for section: Int) -> DateInfo
}

final class CalendarViewModel: ICalendarViewModel {
    struct Section<ItemType> {
        let dateInfo: DateInfo // TODO: refactoring
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
    
    func tableViewRow(for indexPath: IndexPath) -> TodoItem {
        return item(for: indexPath).items[indexPath.row]
    }
    
    func collectionViewRow(for indexPath: IndexPath) -> DateInfo {
        return items[indexPath.row].dateInfo
    }
    
    func tableViewHeader(for section: Int) -> DateInfo {
        return items[section].dateInfo
    }
    
    private static func groupTodoItemsByDate(_ items: [TodoItem]) -> [Section<TodoItem>] {
        let groupedDictionary = Dictionary(grouping: items) {
            $0.creationDate.strip(to: .days)
        }
        let sections = groupedDictionary.map { (key, value) in
            // FIXME: - connect logic tableview
            let dateInfo = DateInfo(date: key, isSelected: value.count > 10)
            return Section(dateInfo: dateInfo, items: value)
        }
        return sections.sorted { $0.dateInfo.date < $1.dateInfo.date }
    }
}
