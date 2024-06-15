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
        case unknown
    }
    private(set) var todoItems: [TodoItem] = []
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
    @discardableResult
    mutating func loadFromFile(named fileName: String, format: FileFormat = .json) -> FileError? {
        var result: Result<[TodoItem], FileError>
        
        switch format {
        case .json: result = loadFromJSONFile(named: fileName)
        case .csv: result = loadFromCSVFile(named: fileName)
        }
        
        switch result {
        case .success(let items):
            self.todoItems = items
            return nil
        case .failure(let error):
            return error
        }
    }
    
    private func loadFromJSONFile(named fileName: String) -> Result<[TodoItem], FileError> {
        do {
            let url = try getDocumentsDirectory().appendingPathComponent(fileName)
            guard FileManager.default.fileExists(atPath: url.path) 
            else { return .failure(.fileNotFound) }
            let data = try Data(contentsOf: url)
            guard let jsonArray = try JSONSerialization.jsonObject(with: data, options: []) as? [TodoItem.JSONType] else {
                return .failure(.dataCorrupted)
            }
            let items = jsonArray.compactMap { TodoItem.parse(json: $0) }
            return .success(items)
        } catch {
            return .failure(.unknown)
        }
    }
    
    private func loadFromCSVFile(named fileName: String) -> Result<[TodoItem], FileError> {
        do {
            let url = try getDocumentsDirectory().appendingPathComponent(fileName)
            guard FileManager.default.fileExists(atPath: url.path) 
            else { return .failure(.fileNotFound) }
            let csvString = try String(contentsOf: url)
            let items = csvString.split(separator: "\n").compactMap { TodoItem.parse(csv: String($0)) }
            return .success(items)
        } catch {
            return .failure(.unknown)
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
        switch format {
        case .json:
            return saveToJSONFile(named: fileName)
        case .csv:
            return saveToCSVFile(named: fileName)
        }
    }

    private func saveToJSONFile(named fileName: String) -> FileError? {
        do {
            let jsonArray = todoItems.map { $0.json }
            let jsonData = try JSONSerialization.data(withJSONObject: jsonArray, options: .prettyPrinted)
            let url = try getDocumentsDirectory().appendingPathComponent(fileName)
            try jsonData.write(to: url)
            return nil
        } catch {
            return .writeToFileFailed
        }
    }
    
    private func saveToCSVFile(named fileName: String) -> FileError? {
        do {
            let csvString = todoItems.map { $0.csv }.joined(separator: "\n")
            let url = try getDocumentsDirectory().appendingPathComponent(fileName)
            try csvString.write(to: url, atomically: true, encoding: .utf8)
            return nil
        } catch {
            return .writeToFileFailed
        }
    }
}

// MARK: - Update
extension FileCache { }

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
    private func getDocumentsDirectory() throws -> URL {
        let urls = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        guard let first = urls.first else { throw FileError.directoryNotFound }
        return first
    }
}
