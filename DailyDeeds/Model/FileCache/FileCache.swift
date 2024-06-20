//
//  FileCache.swift
//  DailyDeeds
//
//  Created by Дмитрий Корчагин on 6/15/24.
//

import Foundation

struct FileCache {
    enum FileFormat {
        case json
        case csv
    }
    enum FileError: Error {
        case fileNotFound
        case dataCorrupted
        case parseFailed
        case writeToFileFailed
        case directoryNotFound
        case loadFromJSONFileFailed
        case loadFromCSVFileFailed
        case fileAlreadyExists
        case unknown
    }
    private(set) var todoItems: Array<TodoItem> = []
}

// MARK: - Create
extension FileCache {
    /// Adds a new todo item to the cache if an item with the same identifier does not already exist.
    /// - Parameter item: The `TodoItem` to add to the cache.
    ///
    /// If a task with the same identifier (`id`) already exists in the cache, the new item is not added.
    /// This ensures uniqueness of tasks in the cache based on their identifier.
    mutating func addTodoItem(_ item: TodoItem) {
        if !todoItems.contains(where: { $0.id == item.id }) {
            todoItems.append(item)
        }
    }
    /// Adds a new todo items to the cache if an items with the same identifiers do not already exist.
    /// - Parameter items: The array of `TodoItem` to add to the cache.
    mutating func addTodoItems(_ items: TodoItem...) {
        items.forEach { addTodoItem($0) }
    }
}

// MARK: - Read
extension FileCache {
    /**
     Loads todo items from a file with the specified name and format into the `todoItems` array.
     
     - Parameters:
     - fileName: The name of the file from which to load data.
     - format: The file format from which to load data (default is `.json`).
     
     - Returns: An optional `FileError` indicating an error that occurred during the loading process, or `nil` if successful. If an error occurs, it will detail the specific nature of the failure, such as file not found or data corruption.
     
     - Note: If the specified file format is `.json`, the function expects JSON formatted data. If `.csv` is specified, the function expects CSV formatted data.
     */
    mutating func loadFromFile(named fileName: String, format: FileFormat) -> Result<[TodoItem], FileError> {
        do {
            let url = try getDocumentsDirectory().appendingPathComponent(fileName)
            guard FileManager.default.fileExists(atPath: url.path) else { return .failure(.fileNotFound) }
            
            let result: Result<[TodoItem], FileError>
            switch format {
            case .json: result = loadFromJSONFile(with: url)
            case .csv: result = loadFromCSVFile(with: url)
            }
            return result
        } catch {
            return .failure(error)
        }
    }
    
    private func loadFromJSONFile(with url: URL) -> Result<[TodoItem], FileError> {
        do {
            let data = try Data(contentsOf: url)
            guard let jsonArray = try JSONSerialization.jsonObject(with: data) as? [TodoItem.JSONType]
            else { return .failure(.dataCorrupted) }
            
            let items = jsonArray.compactMap { TodoItem.parse(json: $0) }
            return .success(items)
        } catch {
            return .failure(.loadFromJSONFileFailed)
        }
    }
    
    private func loadFromCSVFile(with url: URL) -> Result<[TodoItem], FileError> {
        do {
            let csvString = try String(contentsOf: url)
            let items = csvString.split(separator: "\n").compactMap { TodoItem.parse(csv: String($0)) }
            return .success(items)
        } catch {
            return .failure(.loadFromCSVFileFailed)
        }
    }
}

// MARK: - Save
extension FileCache {
    /**
     Saves the current `todoItems` array to a file with the specified name and format.
     
     - Parameters:
     - fileName: The name of the file to which the data should be saved.
     - format: The file format in which the data should be saved (default is `.json`).
     
     - Returns: An optional `FileError` indicating an error that occurred during the saving process, or `nil` if successful. If an error occurs, it will detail the specific nature of the failure, such as file not found or failure to write.
     
     - Note: If the specified file format is `.json`, the data will be saved in JSON format. If `.csv` is specified, the data will be saved in CSV format.
     */
    @discardableResult
    func saveToFile(named fileName: String, format: FileFormat = .json) -> FileError? {
        do {
            let url = try getDocumentsDirectory().appendingPathComponent(fileName)
            
            switch format {
            case .json: return saveToJSONFile(url: url)
            case .csv: return saveToCSVFile(url: url)
            }
        } catch {
            return error
        }
    }
    
    private func saveToJSONFile(url: URL) -> FileError? {
        do {
            let jsonArray = todoItems.jsonArray
            let jsonData = try JSONSerialization.data(withJSONObject: jsonArray, options: .prettyPrinted)
            try jsonData.write(to: url)
            return nil
        } catch {
            return .writeToFileFailed
        }
    }
    
    private func saveToCSVFile(url: URL) -> FileError? {
        do {
            let csvString = todoItems.map { $0.csv }.joined(separator: "\n")
            try csvString.write(to: url, atomically: true, encoding: .utf8)
            return nil
        } catch {
            return .writeToFileFailed
        }
    }
}

// MARK: - Delete
extension FileCache {
    /// Removes a todo item from the cache based on its identifier.
    /// - Parameter id: The identifier of the todo item to remove.
    mutating func removeTodoItem(by id: String) {
        todoItems.removeAll { $0.id == id }
    }
    
    /// Removes all todo items from the cache.
    mutating func removeAllTodoItems() {
        todoItems.removeAll()
    }
}

// MARK: - Supporting
extension FileCache {
    func getDocumentsDirectory() throws(FileError) -> URL {
        let urls = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        guard let first = urls.first else { throw FileError.directoryNotFound }
        return first
    }
}
