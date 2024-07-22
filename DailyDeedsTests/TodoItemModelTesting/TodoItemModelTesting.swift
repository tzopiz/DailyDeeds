//
//  TodoItemModelTesting.swift
//  DailyDeedsTests
//
//  Created by Дмитрий Корчагин on 6/16/24.
//

@testable import DailyDeeds
import FileCache
import XCTest

final class TodoItemModelTesting: XCTestCase {
    typealias Keys = TodoItem.CodingKeys
    private var model: TodoItemModel!
    private let fileNameJSON = "test_tasks.json"
    private let fileNameCSV = "test_tasks.csv"
    private let todoitem = TodoItem(
        id: "1",
        text: "test text for test task",
        isDone: false,
        creationDate: .now,
        importance: .high,
        modificationDate: .now, deadline: nil
    )

    override func setUp() async throws {
        try await super.setUp()
        model = await TodoItemModel()
    }

    override func tearDown() {
        super.tearDown()
        model = nil
    }

    @MainActor
    override func setUpWithError() throws {
        try super.setUpWithError()
        model = TodoItemModel()
        model.updateList([])
    }

    override func tearDownWithError() throws {
        model = nil
        try super.tearDownWithError()
    }

    func testAddTodoItem() {
        model.append(todoitem)
        XCTAssertEqual(model.items.count, 1)
        XCTAssertEqual(model.items.first?.id, "1")
    }

    func testAddTodoItemDuplicate() {
        model.append(todoitem)
        model.append(todoitem)
        XCTAssertEqual(model.items.count, 1)
    }

    func testRemoveTodoItem() {
        let id = "2"
        let todoitem2 = TodoItem(
            id: id,
            text: "test text for test task",
            isDone: false,
            creationDate: .now,
            importance: .medium,
            modificationDate: .now,
            deadline: nil
        )
        model.append(todoitem)
        model.append(todoitem2)
        model.remove(with: todoitem.id)
        XCTAssertEqual(model.items.count, 1)
        XCTAssertEqual(model.items.first?.id, id)
    }

    func testRemoveAllTodoItems() {
        let todoitem2 = TodoItem(
            id: "2",
            text: "test text for test task",
            isDone: false,
            creationDate: .now,
            importance: .high,
            modificationDate: .now,
            deadline: nil
        )
        model.append(todoitem)
        model.append(todoitem2)
        for item in model.items {
            model.remove(with: item.id)
        }
        XCTAssertTrue(model.items.isEmpty)
    }

    func testSaveToJSONFile() throws {
        let todoitem2 = TodoItem(
            id: "2",
            text: "test text for test task",
            isDone: false,
            creationDate: .now,
            importance: .low,
            modificationDate: .now,
            deadline: nil
        )
        let todoitem3 = TodoItem(
            id: "3",
            text: "test text for test task",
            isDone: false,
            creationDate: .now,
            importance: .medium,
            modificationDate: .now,
            deadline: nil
        )

        model.append(todoitem)
        model.append(todoitem2)
        model.append(todoitem3)

        model.save(to: fileNameJSON, format: .json)

        let url = try getDocumentsDirectory().appendingPathComponent(fileNameJSON)
        let data = try Data(contentsOf: url)
        let jsonArray = try JSONSerialization.jsonObject(with: data) as? [JSONDictionary]

        XCTAssertEqual(jsonArray?.count, 3)
        try FileManager.default.removeItem(at: url)
    }

    func testSaveToCSVFile() throws {
        let date = Date.now
        let id = "3"
        let text = "test text for test task"
        let importance: Importance = .high
        let hexColor = "#FFFFFF"
        let isDone = false
        let todoitem = TodoItem(
            id: id,
            text: text,
            isDone: isDone,
            hexColor: hexColor,
            creationDate: date,
            importance: importance,
            modificationDate: date,
            deadline: nil
        )

        model.append(todoitem)

        model.save(to: fileNameCSV, format: .csv)

        let url = try getDocumentsDirectory().appendingPathComponent(fileNameCSV)
        let csvString = try String(contentsOf: url)

        XCTAssertEqual(
            csvString,
            "\(id),\(text),\(isDone),\(importance.rawValue),\(hexColor),\(date.toString()),,\(date.toString())"
        )

        try FileManager.default.removeItem(at: url)
    }

    func testLoadFromJSONFile() throws {
        let date = Date.now
        let id = "1231231"
        let text = "Test Task"
        let isDone = false
        let hexColor = "#FFFFFF"
        let item = TodoItem(
            id: id,
            text: text,
            isDone: isDone,
            hexColor: hexColor,
            creationDate: date,
            modificationDate: date
        )
        
        model.updateList([item])
        model.save(to: fileNameJSON, format: .json)

        model.loadItems(from: fileNameJSON, format: .json)
        XCTAssertEqual(model.items.count, 1)
        XCTAssertEqual(model.items.first?.id, id)
        XCTAssertEqual(model.items.first?.importance, .medium)
        XCTAssertNil(model.items.first?.deadline)
        
        let url = try getDocumentsDirectory().appendingPathComponent(fileNameJSON)
        try FileManager.default.removeItem(at: url)
    }

    func testLoadFromCSVFile() throws {
        let date = Date.now
        let id = "1"
        let text = "Test Task"
        let isDone = false
        let importance: Importance = .medium
        let hexColor = "#FFFFFF"
        let csv = "\(id),\(text),\(isDone),\(importance.rawValue),\(hexColor),\(date.toString()),,\(date.toString())"
        let url = try getDocumentsDirectory().appendingPathComponent(fileNameCSV)
        try csv.write(to: url, atomically: true, encoding: .utf8)

        let items = model.loadItems(from: fileNameCSV, format: .csv)

        XCTAssertEqual(items?.count, 1)
        XCTAssertEqual(items?.first?.id, id)
        XCTAssertNil(items?.first?.deadline)

        try FileManager.default.removeItem(at: url)
    }
    enum MockError: Error {
        case error
    }
    private func getDocumentsDirectory() throws -> URL {
        let urls = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        guard let first = urls.first else { throw MockError.error }
        return first
    }
}
