//
//  CalendarViewModel.swift
//  DailyDeeds
//
//  Created by Дмитрий Корчагин on 6/30/24.
//

import UIKit
import UIComponents

protocol ICalendarViewModel: ICollectionViewModel, IBaseTodoItemViewModel {
    var numberOfSections: Int { get }
    func numberOfRows(in: Int) -> Int
    func tableViewCellItem(for indexPath: IndexPath) -> TodoItem
    func collectionViewCellItem(for indexPath: IndexPath) -> DateInfo
    func tableViewHeader(for section: Int) -> DateInfo
}

final class CalendarViewModel: ObservableObject, ICalendarViewModel {
    struct Section<ItemType, Info> {
        let info: Info
        let todoItems: [ItemType]
    }
    
    @Published 
    var model: TodoItemModel
    
    var title: String?
    var navigationDelegate: ViewModelNavigationDelegate?
    var items: [Section<TodoItem, DateInfo>] {
        CalendarViewModel.groupTodoItemsByDate(model.items)
    }
    
    var numberOfSections: Int {
        items.count
    }
    
    init(model: TodoItemModel) {
        self.model = model
        self.title = "Мои дела"
    }
    
    func item(for indexPath: IndexPath) -> Section<TodoItem, DateInfo> {
        return items[indexPath.section]
    }
    
    func numberOfRows(in section: Int) -> Int {
        items[section].todoItems.count
    }
    
    func tableViewCellItem(for indexPath: IndexPath) -> TodoItem {
        return items[indexPath.section].todoItems[indexPath.row]
    }
    
    func tableViewHeader(for section: Int) -> DateInfo {
        return items[section].info
    }
    
    func collectionViewCellItem(for indexPath: IndexPath) -> DateInfo {
        return items[indexPath.row].info
    }
    
    private static func groupTodoItemsByDate(_ items: [TodoItem]) -> [Section<TodoItem, DateInfo>] {
        let groupedDictionary = Dictionary(grouping: items) { item in
            return item.deadline?.strip(to: .days)
        }
        
        let sections = groupedDictionary.map { (key, value) in
            let dateInfo = DateInfo(date: key)
            return Section(info: dateInfo, todoItems: value)
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
