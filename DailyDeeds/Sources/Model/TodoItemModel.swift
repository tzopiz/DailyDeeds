//
//  TodoItemModel.swift
//  DailyDeeds
//
//  Created by Дмитрий Корчагин on 6/15/24.
//

import Foundation

final class TodoItemModel: ObservableObject {
    enum FileFormat {
        case json
        case csv
    }
    
    enum FileError: Error {
        case fileNotFound
        case dataCorrupted
        case parseFailed
        case writeToFileFailed
        case incorrectFileName
        case directoryNotFound
        case loadFromJSONFileFailed
        case loadFromCSVFileFailed
        case fileAlreadyExists
        case unknown
    }
    
    @Published
    private(set) var items: Array<TodoItem>
    
    init(items: Array<TodoItem>) {
        self.items = items
    }
}

// MARK: - Update
extension TodoItemModel {
    func append(_ item: TodoItem) {
        if !items.contains(where: { $0.id == item.id }) {
            items.append(item)
        }
    }
    
    func update(_ item: TodoItem) {
        if let index = items.firstIndex(where: { $0.id == item.id }) {
            items[index] = item
        } else {
            items.append(item)
        }
    }
    
    func move(fromOffsets indices: IndexSet, toOffset newOffset: Int) {
        items.move(fromOffsets: indices, toOffset: newOffset)
    }
}

// MARK: - Read
extension TodoItemModel {
    func loadFromFile(named fileName: String, format: FileFormat) -> Result<[TodoItem], FileError> {
        do {
            let url = try getDocumentsDirectory().appendingPathComponent(fileName)
            guard FileManager.default.fileExists(atPath: url.path) else { return .failure(.fileNotFound) }
            
            let result: Result<[TodoItem], FileError>
            switch format {
            case .json: result = loadFromJSONFile(with: url)
            case .csv: result = loadFromCSVFile(with: url)
            }
            return result
        } catch let error as FileError {
            return .failure(error)
        } catch {
            return .failure(.unknown)
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
extension TodoItemModel {
    @discardableResult
    func saveToFile(named fileName: String, format: FileFormat = .json) -> FileError? {
        do {
            let url = try getDocumentsDirectory().appendingPathComponent(fileName)
            switch format {
            case .json: return saveToJSONFile(with: url)
            case .csv: return saveToCSVFile(with: url)
            }
        } catch let error as FileError {
            return error
        } catch {
            return .unknown
        }
    }
    
    private func saveToJSONFile(with url: URL) -> FileError? {
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: items.jsonArray, options: .prettyPrinted)
            try jsonData.write(to: url)
            return nil
        } catch {
            return .writeToFileFailed
        }
    }
    
    private func saveToCSVFile(with url: URL) -> FileError? {
        do {
            let csvString = items.map { $0.csv }.joined(separator: "\n")
            try csvString.write(to: url, atomically: true, encoding: .utf8)
            return nil
        } catch {
            return .writeToFileFailed
        }
    }
}

// MARK: - Delete
extension TodoItemModel {
    func remove(with id: String) {
        items.removeAll { $0.id == id }
    }
    
    func remove(at offsets: IndexSet) {
        items.remove(atOffsets: offsets)
    }
}

// MARK: - Supporting
extension TodoItemModel {
    func getDocumentsDirectory() throws -> URL {
        let urls = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        guard let first = urls.first else { throw FileError.directoryNotFound }
        return first
    }
}
