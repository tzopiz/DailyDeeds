//
//  TodoItemModelTesting.swift
//  DailyDeedsTests
//
//  Created by Дмитрий Корчагин on 6/16/24.
//

import XCTest
@testable import DailyDeeds

final class TodoItemModelTesting: XCTestCase {
    typealias Keys = TodoItem.CodingKeys
    private var fileCache: TodoItemModel!
    private let fileNameJSON = "test_tasks.json"
    private let fileNameCSV = "test_tasks.csv"
    private let todoitem = TodoItem(
        id: "1", text: "test text for test task",
        isDone: false, importance: .high,
        creationDate: .now, deadline: nil,
        modificationDate: .now
    )
    
    override func setUp() async throws {
        try await super.setUp()
        fileCache = TodoItemModel()
    }
    
    override func tearDown() {
        super.tearDown()
        fileCache = nil
    }
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        fileCache = TodoItemModel()
    }
    
    override func tearDownWithError() throws {
        fileCache = nil
        try super.tearDownWithError()
    }
    
    func testAddTodoItem() {
        fileCache.append(todoitem)
        XCTAssertEqual(fileCache.items.count, 1)
        XCTAssertEqual(fileCache.items.first?.id, "1")
    }
    
    func testAddTodoItem_Duplicate() {
        fileCache.append(todoitem)
        fileCache.append(todoitem)
        XCTAssertEqual(fileCache.items.count, 1)
    }
    
    func testRemoveTodoItem() {
        let id = "2"
        let todoitem2 = TodoItem(
            id: id, text: "test text for test task",
            isDone: false, importance: .medium,
            creationDate: .now, deadline: nil,
            modificationDate: .now
        )
        fileCache.append(todoitem)
        fileCache.append(todoitem2)
        fileCache.remove(with: todoitem.id)
        XCTAssertEqual(fileCache.items.count, 1)
        XCTAssertEqual(fileCache.items.first?.id, id)
    }
    
    func testRemoveAllTodoItems() {
        let todoitem2 = TodoItem(
            id: "2", text: "test text for test task",
            isDone: false, importance: .high,
            creationDate: .now, deadline: nil,
            modificationDate: .now
        )
        fileCache.append(todoitem)
        fileCache.append(todoitem2)
        for item in fileCache.items {
            fileCache.remove(with: item.id)
        }
        XCTAssertTrue(fileCache.items.isEmpty)
    }
    
    func testSaveToFile_JSON() throws {
        let todoitem2 = TodoItem(
            id: "2", text: "test text for test task",
            isDone: false, importance: .low,
            creationDate: .now, deadline: nil,
            modificationDate: .now
        )
        let todoitem3 = TodoItem(
            id: "3", text: "test text for test task",
            isDone: false, importance: .medium,
            creationDate: .now, deadline: nil,
            modificationDate: .now
        )
        
        fileCache.append(todoitem)
        fileCache.append(todoitem2)
        fileCache.append(todoitem3)
        
        let error = fileCache.saveToFile(named: fileNameJSON, format: .json)
        
        XCTAssertNil(error)
        
        let url = try fileCache.getDocumentsDirectory().appendingPathComponent(fileNameJSON)
        let data = try Data(contentsOf: url)
        let jsonArray = try JSONSerialization.jsonObject(with: data, options: []) as? [TodoItem.JSONType]
        
        XCTAssertEqual(jsonArray?.count, 3)
        try FileManager.default.removeItem(at: url)
    }
    
    func testSaveToFile_CSV() throws {
        let date = Date.now
        let id = "3"
        let text = "test text for test task"
        let importance: Importance = .high
        let hexColor = "#FFFFFF"
        let isDone = false
        let todoitem = TodoItem(
            id: id, text: text, isDone: isDone,
            importance: importance, hexColor: hexColor,
            creationDate: date, deadline: nil,
            modificationDate: date
        )
        
        fileCache.append(todoitem)
        
        let error = fileCache.saveToFile(named: fileNameCSV, format: .csv)
        
        XCTAssertNil(error)
        
        let url = try fileCache.getDocumentsDirectory().appendingPathComponent(fileNameCSV)
        let csvString = try String(contentsOf: url)
        
        XCTAssertEqual(
            csvString,
            "\(id),\(text),\(isDone),\(importance.rawValue),\(hexColor),\(date.toString()),,\(date.toString())"
        )
        
        try FileManager.default.removeItem(at: url)
    }
    
    func testLoadFromFile_JSON() throws {
        let date = Date.now
        let id = "1231231"
        let text = "Test Task"
        let isDone = false
        let hexColor = "#FFFFFF"
        let json = """
        [{
            "\(Keys.id)": "\(id)",
            "\(Keys.text)": "\(text)",
            "\(Keys.isDone)": \(isDone),
            "\(Keys.hexColor)": "\(hexColor)",
            "\(Keys.creationDate)": "\(date.toString())"
        }]
        """
        let url = try fileCache.getDocumentsDirectory().appendingPathComponent(fileNameJSON)
        try json.data(using: .utf8)?.write(to: url)
        
        let result = fileCache.loadFromFile(named: fileNameJSON, format: .json)
        switch result {
        case .success(let item):
            XCTAssertEqual(item.count, 1)
            XCTAssertEqual(item.first?.id , id)
            XCTAssertEqual(item.first?.importance, .medium)
            XCTAssertNil(item.first?.deadline)
        case .failure(_):
            XCTFail()
        }
        
        try FileManager.default.removeItem(at: url)
    }
    
    func testLoadFromFile_CSV() throws {
        let date = Date.now
        let id = "1"
        let text = "Test Task"
        let isDone = false
        let importance: Importance = .medium
        let hexColor = "#FFFFFF"
        let csv = "\(id),\(text),\(isDone),\(importance.rawValue),\(hexColor),\(date.toString()),,"
        let url = try fileCache.getDocumentsDirectory().appendingPathComponent(fileNameCSV)
        try csv.write(to: url, atomically: true, encoding: .utf8)
        
        let result = fileCache.loadFromFile(named: fileNameCSV, format: .csv)
        switch result {
        case .success(let items):
            XCTAssertEqual(items.count, 1)
            XCTAssertEqual(items.first?.id, id)
            XCTAssertNil(items.first?.deadline)
        case .failure(_):
            XCTFail()
        }
        
        try FileManager.default.removeItem(at: url)
    }
}
