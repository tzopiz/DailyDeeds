//
//  CalendarViewModel.swift
//  DailyDeeds
//
//  Created by Дмитрий Корчагин on 6/30/24.
//

import UIKit
import UIComponents

protocol ICalendarViewModel: ICollectionViewModel {
    func tableViewCell(for indexPath: IndexPath) -> TodoItem
    func collectionViewCell(for indexPath: IndexPath) -> DateInfo
    func tableViewHeader(for section: Int) -> DateInfo
}

final class CalendarViewModel: ICalendarViewModel {
    struct Section<ItemType, Info> {
        let info: Info
        let items: [ItemType]
    }
    
    var title: String?
    var items: [Section<TodoItem, DateInfo>]
    var navigationDelegate: ViewModelNavigationDelegate?
    
    init(todoItems: [TodoItem]) {
        self.title = "Мои дела"
        self.items = CalendarViewModel.groupTodoItemsByDate(todoItems)
    }
    
    func item(for indexPath: IndexPath) -> Section<TodoItem, DateInfo> {
        return items[indexPath.section]
    }
    
    func tableViewCell(for indexPath: IndexPath) -> TodoItem {
        return item(for: indexPath).items[indexPath.row]
    }
    
    func collectionViewCell(for indexPath: IndexPath) -> DateInfo {
        return items[indexPath.row].info
    }
    
    func tableViewHeader(for section: Int) -> DateInfo {
        return items[section].info
    }
    
    private static func groupTodoItemsByDate(_ items: [TodoItem]) -> [Section<TodoItem, DateInfo>] {
        let groupedDictionary = Dictionary(grouping: items) { (item: TodoItem) -> Date? in
            return item.deadline?.strip(to: .days)
        }
        
        let sections = groupedDictionary.map { (key, value) in
            let dateInfo = DateInfo(date: key)
            return Section(info: dateInfo, items: value)
        }
        
        return sections.sorted {
            if let date1 = $0.info.date, let date2 = $1.info.date {
                return date1 < date2
            } else {
                return $0.info.date != nil
            }
        }
    }
}
