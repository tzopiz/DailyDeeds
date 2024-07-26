//
//  SQLStorageManager.swift
//  DailyDeeds
//
//  Created by Дмитрий Корчагин on 7/25/24.
//

import Foundation
import SQLite
import SwiftData

final class SQLiteStorageManager: IDataStorageManager {
    typealias Element = TodoItem
    
    private let db: Connection
    private let todoItems: Table
    private let id: SQLite.Expression<String>
    private let text: SQLite.Expression<String>
    private let isDone: SQLite.Expression<Bool>
    private let hexColor: SQLite.Expression<String>
    private let creationDate: SQLite.Expression<Date>
    private let category: SQLite.Expression<String>
    private let importance: SQLite.Expression<Int>
    private let modificationDate: SQLite.Expression<Date>
    private let lastUpdatedDevice: SQLite.Expression<String>
    private let deadline: SQLite.Expression<Date?>
    
    init(dbPath: String) {
        do {
            db = try Connection(dbPath)
            todoItems = Table("todoItems")
            id = SQLite.Expression<String>("id")
            text = SQLite.Expression<String>("text")
            isDone = SQLite.Expression<Bool>("isDone")
            hexColor = SQLite.Expression<String>("hexColor")
            creationDate = SQLite.Expression<Date>("creationDate")
            category = SQLite.Expression<String>("category")
            importance = SQLite.Expression<Int>("importance")
            modificationDate = SQLite.Expression<Date>("modificationDate")
            lastUpdatedDevice = SQLite.Expression<String>("lastUpdatedDevice")
            deadline = SQLite.Expression<Date?>("deadline")
            
            try db.run(todoItems.create(ifNotExists: true) { t in
                t.column(id, primaryKey: true)
                t.column(text)
                t.column(isDone)
                t.column(hexColor)
                t.column(creationDate)
                t.column(category)
                t.column(importance)
                t.column(modificationDate)
                t.column(lastUpdatedDevice)
                t.column(deadline)
            })
        } catch {
            fatalError("Unable to initialize database: \(error)")
        }
    }
    
    func fetchTasksSorted(by sortOrder: TaskCriteria.SortType) -> [Element] {
        do {
            let order: [Expressible]
            switch sortOrder {
            case .byCreationDate(let orderType):
                order = orderType.isAscending ? [creationDate.asc] : [creationDate.desc]
            case .byDeadline(let orderType):
                order = orderType.isAscending ? [deadline.asc] : [deadline.desc]
            case .byImportance(let orderType):
                order = orderType.isAscending ? [importance.asc] : [importance.desc]
            case .byLastModifiedDate(let orderType):
                order = orderType.isAscending ? [modificationDate.asc] : [modificationDate.desc]
            case .byCompletionStatus(let orderType):
                order = orderType.isAscending ? [isDone.asc] : [isDone.desc]
            }
            
            return try db.prepare(todoItems.order(order)).map { row in
                TodoItem(
                    id: row[id],
                    text: row[text],
                    isDone: row[isDone],
                    hexColor: row[hexColor],
                    creationDate: row[creationDate],
                    category: Category.default,
                    importance: row[importance] == 0 ? .low : row[importance] == 1 ? .medium : .high,
                    modificationDate: row[modificationDate],
                    lastUpdatedDevice: row[lastUpdatedDevice],
                    deadline: row[deadline]
                )
            }
        } catch {
            fatalError("Fetch failed: \(error)")
        }
    }
    
    func fetchAll() -> [Element] {
        return fetchTasksSorted(by: .byCreationDate(.ascending))
    }
    
    func append(_ item: Element) {
        do {
            try db.run(todoItems.insert(
                id <- item.id,
                text <- item.text,
                isDone <- item.isDone,
                hexColor <- item.hexColor,
                creationDate <- item.creationDate,
                category <- item.category.name,
                importance <- item.importance.order,
                modificationDate <- item.modificationDate,
                lastUpdatedDevice <- item.lastUpdatedDevice,
                deadline <- item.deadline
            ))
        } catch {
            fatalError("Insert failed: \(error)")
        }
    }
    
    func updateAllItems(to items: [Element]) {
        deleteAll()
        for item in items {
            append(item)
        }
    }
    
    func delete(_ item: Element) {
        do {
            let itemToDelete = todoItems.filter(id == item.id)
            try db.run(itemToDelete.delete())
        } catch {
            fatalError("Delete failed: \(error)")
        }
    }
    
    func deleteAll() {
        do {
            try db.run(todoItems.delete())
        } catch {
            fatalError("Delete all failed: \(error)")
        }
    }
}
