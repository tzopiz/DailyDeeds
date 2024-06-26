//
//  TestCSVParsable.swift
//  DailyDeedsTests
//
//  Created by Дмитрий Корчагин on 6/14/24.
//

import XCTest
@testable import DailyDeeds

final class TestCSVParsable: XCTestCase {
    private let creationDate = Date()
    private let deadline = Date().advanced(by: 200)
    private let modificationDate = Date().advanced(by: 10)
    
    func testCSVSerialization() {
        let id = "1"
        let text = "Задача для тестирования CSV"
        let isDone = false
        let importance = Importance.high
        let hexColor = "#FFFFFF"
        let item = TodoItem(
            id: id,
            text: text,
            isDone: isDone,
            importance: importance,
            hexColor: hexColor,
            creationDate: creationDate,
            deadline: deadline,
            modificationDate: modificationDate
        )
        let expectedCSV =
        "\(id),\(text),\(isDone),\(importance.rawValue),\(hexColor),\(self.creationDate.toString()),\(self.deadline.toString()),\(self.modificationDate.toString())"
        
        XCTAssertEqual(item.csv, expectedCSV)
    }
    
    func testCSVSerialization2() {
        let id = "1"
        let text = "Задача для тестирования CSV"
        let isDone = false
        let importance = Importance.high
        let hexColor = "#FFFFFF"
        let item = TodoItem(
            id: id,
            text: text,
            isDone: isDone,
            importance: importance,
            creationDate: creationDate
        )
        let expectedCSV =
        "\(id),\(text),\(isDone),\(importance.rawValue),\(hexColor),\(creationDate.toString()),,"
        
        XCTAssertEqual(item.csv, expectedCSV)
    }
    
    func testCSVDeserialization() {
        let id = "123-234-4455"
        let text = "Задача для распарсинга"
        let isDone = true
        let importance = Importance.low
        let hexColor = "#FFFFFF"
        let csvString = "\(id),\(text),\(isDone),\(importance.rawValue),\(hexColor),\(creationDate.toString()),\(deadline.toString()),\(modificationDate.toString())"
        
        guard let parsedItem = TodoItem.parse(csv: csvString) else {
            XCTFail("Failed to parse CSV string")
            return
        }
        
        XCTAssertEqual(parsedItem.id, id)
        XCTAssertEqual(parsedItem.text, text)
        XCTAssertEqual(parsedItem.importance, importance)
        XCTAssertEqual(parsedItem.isDone, isDone)
        XCTAssertEqual(parsedItem.hexColor, hexColor)
        XCTAssertEqual(parsedItem.creationDate.toString(), creationDate.toString())
        XCTAssertEqual(parsedItem.deadline?.toString(), deadline.toString())
        XCTAssertEqual(parsedItem.modificationDate?.toString(), modificationDate.toString())
    }
    
    func testCSVDeserializationEscapeText() {
        let id = "1"
        let text = "Задача,для,распарсинга"
        let isDone = false
        let importance = Importance.high
        let hexColor = "#FFFFFF"
        let csvString = "\(id),\(text.escapeSpecialCharacters(",")),\(isDone),\(importance.rawValue),\(hexColor),\(creationDate.toString()),,"
        
        guard let parsedItem = TodoItem.parse(csv: csvString) else {
            XCTFail("Failed to parse CSV string")
            return
        }
        
        XCTAssertEqual(parsedItem.id, id)
        XCTAssertEqual(parsedItem.text, text)
        XCTAssertEqual(parsedItem.importance, importance)
        XCTAssertEqual(parsedItem.isDone, isDone)
        XCTAssertEqual(parsedItem.hexColor, hexColor)
        XCTAssertEqual(parsedItem.creationDate.toString(), creationDate.toString())
        XCTAssertNil(parsedItem.deadline)
        XCTAssertNil(parsedItem.modificationDate)
    }
    
    func testFailedCSVDeserialization() {
        let text = "Задача,для,распарсинга"
        let isDone = false
        let importance = Importance.high
        let csvString = ",\(text),\(isDone),\(importance.rawValue),\(creationDate.toString()),,"
        
        if let _ = TodoItem.parse(csv: csvString) {
            XCTFail("Unexpected success in a false test")
        }
    }
}
