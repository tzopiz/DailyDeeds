//
//  IDataStorageManager.swift
//  DailyDeeds
//
//  Created by Дмитрий Корчагин on 7/25/24.
//

import Foundation

protocol IDataStorageManager {
    associatedtype Element
    
    func fetchAll() -> [Element]
    func append(_: Element)
    func updateAllItems(to _: [Element])
    func delete(_: Element)
    func deleteAll()
}
