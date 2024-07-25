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
    
    func fetchAll() -> [Element] {
        do {
            let descriptor = FetchDescriptor<TodoItem>(sortBy: [SortDescriptor(\.creationDate)])
            return try modelContext.fetch(descriptor)
        } catch {
            DDLogError("Fetch failed, \(error).")
            fatalError()
        }
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
        let items = fetchAll()
        for item in items {
            delete(item)
        }
    }
}
