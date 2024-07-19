//
//  TodoItemModel + FileCache.swift
//  DailyDeeds
//
//  Created by Дмитрий Корчагин on 7/19/24.
//

import CocoaLumberjackSwift
import FileCache
import Foundation

extension TodoItemModel {
    func save(to fileName: String, format type: FileFormat = .json) {
        if let error = FileService.saveToFile(items, named: fileName, format: type) {
            DDLogError("Failed to save items to file \(fileName): \(error.localizedDescription)")
        } else {
            DDLogInfo("Successfully saved items to file \(fileName)")
        }
    }
    
    func loadItems(from fileName: String, format type: FileFormat = .json) {
        let result = FileService.loadFromFile(named: fileName, format: type)
        switch result {
        case .success(let items):
            self.updateList(items)
            DDLogInfo("Successfully loaded items from file \(fileName)")
        case .failure(let error):
            DDLogError("Failed to load items from file \(fileName): \(error.localizedDescription)")
        }
    }
}
