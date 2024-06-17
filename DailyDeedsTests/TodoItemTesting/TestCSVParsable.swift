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
        let otherDate = creationDate.advanced(by: 200)
        let item = TodoItem(
            id: "123",
            text: "Задача для тестирования CSV",
            isDone: false,
            importance: .high,
            creationDate: creationDate,
            deadline: otherDate,
            modificationDate: nil
        )
        
        let expectedCSV = "123,Задача для тестирования CSV,false,важная,\(creationDate.toString()),\(otherDate.toString()),"
        
        XCTAssertEqual(item.csv, expectedCSV)
    }
    func testCSVSerialization2() {
        let creationDate = Date()
        let item = TodoItem(
            id: "123",
            text: "Задача для тестирования CSV",
            isDone: false,
            importance: .high,
            creationDate: creationDate,
            deadline: nil,
            modificationDate: Date()
        )
        
        let expectedCSV = "123,Задача для тестирования CSV,false,важная,\(creationDate.toString()),,\(creationDate.toString())"
        
        XCTAssertEqual(item.csv, expectedCSV)
    }
    func testCSVDeserialization() {
        let csvString = "456,Задача для распарсинга,true,неважная,2023-06-15 12:00:00,2023-06-16 12:00:00,2023-06-17 12:00:00"
        
        guard let parsedItem = TodoItem.parse(csv: csvString) else {
            XCTFail("Failed to parse CSV string")
            return
        }
        
        XCTAssertEqual(parsedItem.id, "456")
        XCTAssertEqual(parsedItem.text, "Задача для распарсинга")
        XCTAssertEqual(parsedItem.importance, .low)
        XCTAssertTrue(parsedItem.isDone)
        XCTAssertEqual(parsedItem.creationDate.toString(), "2023-06-15 12:00:00")
        XCTAssertEqual(parsedItem.deadline?.toString(), "2023-06-16 12:00:00")
        XCTAssertEqual(parsedItem.modificationDate?.toString(), "2023-06-17 12:00:00")
    }
    func testCSVDeserialization2() {
        let csvString = "456,Задача для распарсинга,true,неважная,2023-06-15 12:00:00,,2023-06-17 12:00:00"
        
        guard let parsedItem = TodoItem.parse(csv: csvString) else {
            XCTFail("Failed to parse CSV string")
            return
        }
        
        XCTAssertEqual(parsedItem.id, "456")
        XCTAssertEqual(parsedItem.text, "Задача для распарсинга")
        XCTAssertEqual(parsedItem.importance, .low)
        XCTAssertTrue(parsedItem.isDone)
        XCTAssertEqual(parsedItem.creationDate.toString(), "2023-06-15 12:00:00")
        XCTAssertNil(parsedItem.deadline)
        XCTAssertEqual(parsedItem.modificationDate?.toString(), "2023-06-17 12:00:00")
    }

}
