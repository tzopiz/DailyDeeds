//
//  SQLStorageManager.swift
//  DailyDeeds
//
//  Created by Дмитрий Корчагин on 7/25/24.
//

import Foundation
import SwiftData

final class SQLStorageManager: IDataStorageManager {
    
    func fetchAll() -> [TodoItem] {
        return []
    }
    
    func fetchTasksSorted(by _: TaskCriteria.SortType) -> [TodoItem] {
        return []
    }
    
    func append(_: TodoItem) { }
    
    func updateAllItems(to _: [TodoItem]) { }
    
    func delete(_: TodoItem) { }
    
    func deleteAll() { }
}
