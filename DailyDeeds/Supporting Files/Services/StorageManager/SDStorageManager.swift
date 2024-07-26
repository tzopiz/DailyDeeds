//
//  SDStorageManager.swift
//  DailyDeeds
//
//  Created by Дмитрий Корчагин on 7/25/24.
//

import CocoaLumberjackSwift
import Foundation
import SwiftData

final class SDStorageManager: IDataStorageManager {
    typealias Element = TodoItem
    private let modelContext: ModelContext
    
    init(modelContext: ModelContext) {
        self.modelContext = modelContext
    }
    
    func fetchTasksSorted(by sortOrder: TaskCriteria.SortType) -> [Element] {
        do {
            let sortDescriptor: SortDescriptor<TodoItem>
            
            switch sortOrder {
            case .byCreationDate(let order):
                sortDescriptor = SortDescriptor(\.creationDate, order: order.isAscending ? .forward : .reverse)
            case .byDeadline(let order):
                sortDescriptor = SortDescriptor(\.deadline, order: order.isAscending ? .forward : .reverse)
            case .byImportance(let order):
                sortDescriptor = SortDescriptor(\.importance, order: order.isAscending ? .forward : .reverse)
            case .byLastModifiedDate(let order):
                sortDescriptor = SortDescriptor(\.modificationDate, order: order.isAscending ? .forward : .reverse)
            case .byCompletionStatus(let order):
                sortDescriptor = SortDescriptor(\.isDone, order: order.isAscending ? .forward : .reverse)
            }
            
            let descriptor = FetchDescriptor<TodoItem>(sortBy: [sortDescriptor])
            return try modelContext.fetch(descriptor)
        } catch {
            DDLogError("Fetch failed, \(error).")
            fatalError()
        }
    }
    
    func fetchAll() -> [Element] {
        return fetchTasksSorted(by: .byCreationDate(.ascending))
    }
    
    func append(_ item: Element) {
        modelContext.insert(item)
    }
    
    // FIXME: - async?
    func updateAllItems(to items: [Element]) {
        deleteAll()
        for item in items {
            append(item)
        }
    }
    
    func delete(_ item: Element) {
        modelContext.delete(item)
    }
    
    func deleteAll() {
        for item in fetchAll() {
            delete(item)
        }
    }
}
