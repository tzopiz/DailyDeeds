//
//  IBaseTodoItemViewModel + FileCache.swift
//  DailyDeeds
//
//  Created by Дмитрий Корчагин on 7/25/24.
//

import FileCache
import Foundation

extension IBaseTodoItemViewModel {
    func save(to fileName: String, format type: FileFormat = .json) {
        model.save(to: fileName, format: type)
    }

    func loadItems(from fileName: String, format type: FileFormat = .json) {
        model.loadItems(from: fileName, format: type)
    }
}
