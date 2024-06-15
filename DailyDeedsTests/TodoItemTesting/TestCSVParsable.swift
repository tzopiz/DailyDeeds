//
//  TestCSVParsable.swift
//  DailyDeedsTests
//
//  Created by Дмитрий Корчагин on 6/14/24.
//

import XCTest
@testable import DailyDeeds

final class TestCSVParsable: XCTestCase {

    func testCSVSerialization() {
        let creationDate = Date()
        let item = TodoItem(
            id: "123",
            text: "Задача для тестирования CSV",
            importance: .high,
            isDone: false,
            creationDate: creationDate,
            deadline: creationDate.advanced(by: 200),
            modificationDate: nil
        )
        
        let expectedCSV = "123,Задача для тестирования CSV,важная,false,\(TodoItem.string(from: creationDate)),\(TodoItem.string(from: creationDate.advanced(by: 200))),"
        
        XCTAssertEqual(item.csv, expectedCSV)
    }
    func testCSVSerialization2() {
        let creationDate = Date()
        let item = TodoItem(
            id: "123",
            text: "Задача для тестирования CSV",
            importance: .high,
            isDone: false,
            creationDate: creationDate,
            deadline: nil,
            modificationDate: Date()
        )
        
        let expectedCSV = "123,Задача для тестирования CSV,важная,false,\(TodoItem.string(from: creationDate)),,\(TodoItem.string(from: creationDate))"
        
        XCTAssertEqual(item.csv, expectedCSV)
    }
    func testCSVDeserialization() {
        let csvString = "456,Задача для распарсинга,неважная,true,2023-06-15 12:00:00,2023-06-16 12:00:00,2023-06-17 12:00:00"
        
        guard let parsedItem = TodoItem.parse(csv: csvString) else {
            XCTFail("Failed to parse CSV string")
            return
        }
        
        XCTAssertEqual(parsedItem.id, "456")
        XCTAssertEqual(parsedItem.text, "Задача для распарсинга")
        XCTAssertEqual(parsedItem.importance, .low)
        XCTAssertTrue(parsedItem.isDone)
        XCTAssertEqual(TodoItem.string(from: parsedItem.creationDate), "2023-06-15 12:00:00")
        XCTAssertEqual(TodoItem.string(from: parsedItem.deadline), "2023-06-16 12:00:00")
        XCTAssertEqual(TodoItem.string(from: parsedItem.modificationDate), "2023-06-17 12:00:00")
    }
    func testCSVDeserialization2() {
        let csvString = "456,Задача для распарсинга,неважная,true,2023-06-15 12:00:00,,2023-06-17 12:00:00"
        
        guard let parsedItem = TodoItem.parse(csv: csvString) else {
            XCTFail("Failed to parse CSV string")
            return
        }
        
        XCTAssertEqual(parsedItem.id, "456")
        XCTAssertEqual(parsedItem.text, "Задача для распарсинга")
        XCTAssertEqual(parsedItem.importance, .low)
        XCTAssertTrue(parsedItem.isDone)
        XCTAssertEqual(TodoItem.string(from: parsedItem.creationDate), "2023-06-15 12:00:00")
        XCTAssertNil(parsedItem.deadline)
        XCTAssertEqual(TodoItem.string(from: parsedItem.modificationDate), "2023-06-17 12:00:00")
    }

}
