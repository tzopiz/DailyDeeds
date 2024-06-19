//
//  TestFileCacheCreate.swift
//  DailyDeedsTests
//
//  Created by Дмитрий Корчагин on 6/16/24.
//

import XCTest
@testable import DailyDeeds

final class FileCacheTests: XCTestCase {
    
    private var fileCache: FileCache!
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
        fileCache = FileCache()
    }
    override func tearDown() {
        super.tearDown()
        fileCache = nil
    }
    override func setUpWithError() throws {
        try super.setUpWithError()
        fileCache = FileCache()
    }
    
    override func tearDownWithError() throws {
        fileCache = nil
        try super.tearDownWithError()
    }
    
    func testAddTodoItem() {
        fileCache.addTodoItem(todoitem)
        XCTAssertEqual(fileCache.todoItems.count, 1)
        XCTAssertEqual(fileCache.todoItems.first?.id, "1")
    }
    
    func testAddTodoItem_Duplicate() {
        fileCache.addTodoItem(todoitem)
        fileCache.addTodoItem(todoitem)
        XCTAssertEqual(fileCache.todoItems.count, 1)
    }
    
    func testRemoveTodoItem() {
        let id = "2"
        let todoitem2 = TodoItem(
            id: id, text: "test text for test task",
            isDone: false, importance: .medium,
            creationDate: .now, deadline: nil,
            modificationDate: .now
        )
        fileCache.addTodoItem(todoitem)
        fileCache.addTodoItem(todoitem2)
        fileCache.removeTodoItem(by: "1")
        XCTAssertEqual(fileCache.todoItems.count, 1)
        XCTAssertEqual(fileCache.todoItems.first?.id, id)
    }
    
    func testRemoveAllTodoItems() {
        let todoitem2 = TodoItem(
            id: "2", text: "test text for test task",
            isDone: false, importance: .high,
            creationDate: .now, deadline: nil,
            modificationDate: .now
        )
        fileCache.addTodoItem(todoitem)
        fileCache.addTodoItem(todoitem2)
        fileCache.removeAllTodoItems()
        XCTAssertTrue(fileCache.todoItems.isEmpty)
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
        
        fileCache.addTodoItem(todoitem)
        fileCache.addTodoItem(todoitem2)
        fileCache.addTodoItem(todoitem3)
        
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
        let todoitem = TodoItem(
            id: "3", text: "test text for test task",
            isDone: false, importance: .medium,
            creationDate: date, deadline: nil,
            modificationDate: date
        )
        
        fileCache.addTodoItem(todoitem)
        
        let error = fileCache.saveToFile(named: fileNameCSV, format: .csv)
        
        XCTAssertNil(error)
        
        let url = try fileCache.getDocumentsDirectory().appendingPathComponent(fileNameCSV)
        let csvString = try String(contentsOf: url)

        XCTAssertEqual(csvString, "3,test text for test task,false,обычная,\(date.toString()),,\(date.toString())")
        
        try FileManager.default.removeItem(at: url)
    }
    
    func testLoadFromFile_JSON() throws {
        let date = Date.now
        let id = "1231231"
        let json = """
        [{
            "id": "\(id)",
            "text": "Test Task",
            "isDone": false,
            "creationDate": "\(date.toString())"
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
        let csv = "1,Test Task,false,обычная,\(date.toString())"
        let url = try fileCache.getDocumentsDirectory().appendingPathComponent(fileNameCSV)
        try csv.write(to: url, atomically: true, encoding: .utf8)
        
        let result = fileCache.loadFromFile(named: fileNameCSV, format: .csv)
        
        switch result {
        case .success(let items):
            XCTAssertEqual(items.count, 1)
            XCTAssertEqual(items.first?.id, "1")
            XCTAssertNil(items.first?.deadline)
        case .failure(_):
            XCTFail()
        }
        
        try FileManager.default.removeItem(at: url)
    }
}
