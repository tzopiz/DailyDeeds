//
//  FileService.swift
//  DailyDeeds
//
//  Created by Дмитрий Корчагин on 7/19/24.
//

import FileCache
import Foundation

typealias FileError = FileCache<TodoItem>.FileError
typealias FileFormat = FileCache<TodoItem>.FileFormat

struct FileService {
    static func saveToFile<T: JSONParsable>(
        _ items: [T],
        named fileName: String,
        format: FileCache<T>.FileFormat
    ) -> FileCache<T>.FileError? {
        let fileCache = FileCache<T>()
        return fileCache.saveToFile(items, named: fileName, format: format)
    }

    static func loadFromFile<T: JSONParsable>(
        named fileName: String,
        format: FileCache<T>.FileFormat
    ) -> Result<[T], FileCache<T>.FileError> {
        let fileCache = FileCache<T>()
        return fileCache.loadFromFile(named: fileName, format: format)
    }
}
