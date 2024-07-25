//
//  AnyDataStorageManager.swift
//  DailyDeeds
//
//  Created by Дмитрий Корчагин on 7/25/24.
//

import Foundation

final class AnyDataStorageManager<Element>: IDataStorageManager {
    private let _fetchAll: () -> [Element]
    private let _append: (Element) -> Void
    private let _updateAllItemsTo: ([Element]) -> Void
    private let _delete: (Element) -> Void
    private let _deleteAll: () -> Void
    
    init<Storage: IDataStorageManager>(_ storage: Storage) where Storage.Element == Element {
        _fetchAll = storage.fetchAll
        _append = storage.append
        _updateAllItemsTo = storage.updateAllItems
        _delete = storage.delete
        _deleteAll = storage.deleteAll
    }
    
    func fetchAll() -> [Element] {
        return _fetchAll()
    }
    
    func append(_ item: Element) {
        _append(item)
    }
    
    func updateAllItems(to items: [Element]) {
        _updateAllItemsTo(items)
    }
    
    func delete(_ item: Element) {
        _delete(item)
    }
    
    func deleteAll() {
        _deleteAll()
    }
}
