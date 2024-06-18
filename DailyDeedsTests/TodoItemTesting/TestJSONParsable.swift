//
//  TestJSONParsable.swift
//  DailyDeedsTests
//
//  Created by Дмитрий Корчагин on 6/15/24.
//

import XCTest
@testable import DailyDeeds

final class TestJSONParsable: XCTestCase {
    
    func testParseJSON() {
        let date1 = Date(timeIntervalSince1970: TimeInterval(1674990000))
        let date2 = Date(timeIntervalSince1970: TimeInterval(1675000000))
        let date3 = Date(timeIntervalSince1970: TimeInterval(1674991000))
        let json = TodoItem.buildJSON {
            ("id", "123")
            ("text", "Задача из JSON")
            ("isDone", true)
            ("importance", .high)
            ("creationDate", date1)
            ("deadline", date2)
            ("modificationDate", date3)
        }

        
        guard let item = TodoItem.parse(json: json) else {
            XCTFail("Failed to parse JSON into TodoItem")
            return
        }
        
        XCTAssertEqual(item.id, "123")
        XCTAssertEqual(item.text, "Задача из JSON")
        XCTAssertEqual(item.importance, .high)
        XCTAssertEqual(item.isDone, true)
        XCTAssertEqual(item.creationDate, date1)
        XCTAssertEqual(item.deadline, date2)
        XCTAssertEqual(item.modificationDate, date3)
    }
    
    func testJSONRepresentation() {
        let creationDate = Date(timeIntervalSince1970: 1674990000)
        let modificationDate = Date(timeIntervalSince1970: 1674991000)
        let deadline = Date(timeIntervalSince1970: 1675000000)
        
        let item = TodoItem(
            id: "456",
            text: "Еще одна задача из JSON",
            isDone: false,
            importance: .low,
            creationDate: creationDate,
            deadline: deadline,
            modificationDate: modificationDate
        )
        
        let json = item.json
        guard let parsedItem = TodoItem.parse(json: json)
        else {
            XCTFail("unluck TodoItem.parse(:JSONType)")
            return
        }
        
       
        XCTAssertEqual(item.id, parsedItem.id)
        XCTAssertEqual(item.text, parsedItem.text)
        XCTAssertEqual(item.isDone, parsedItem.isDone)
        XCTAssertEqual(item.importance, parsedItem.importance)
        XCTAssertEqual(item.creationDate, parsedItem.creationDate)
        
    }
    
    func testFromJSONString() {
        let date1 = Date(timeIntervalSince1970: TimeInterval(1675990000))
        let date2 = Date(timeIntervalSince1970: TimeInterval(1676000000))
        let date3 = Date(timeIntervalSince1970: TimeInterval(1675991000))
        let jsonString = """
            {
                "id": "789",
                "text": "Еще одна задача из JSON строка",
                "isDone": true,
                "creationDate": "\(date1.toString())",
                "deadline": "\(date2.toString())",
                "modificationDate": "\(date3.toString())"
            }
            """
        
        guard let item = TodoItem.from(jsonString: jsonString)
        else {
            XCTFail("Failed to parse JSON string into TodoItem")
            return
        }
        
        XCTAssertEqual(item.id, "789")
        XCTAssertEqual(item.text, "Еще одна задача из JSON строка")
        XCTAssertEqual(item.importance, .medium)
        XCTAssertEqual(item.isDone, true)
        XCTAssertEqual(item.creationDate, date1)
        XCTAssertEqual(item.deadline, date2)
        XCTAssertEqual(item.modificationDate, date3)
    }
    
    func testMinimalJSON() {
        let date = Date(timeIntervalSince1970: TimeInterval(1675990000))
        let json = TodoItem.buildJSON {
            ("id", "12345")
            ("text", "Минимальная задача")
            ("isDone", false)
            ("creationDate", date)
        }
        
        guard let item = TodoItem.parse(json: json) else {
            XCTFail("Failed to parse minimal JSON into TodoItem")
            return
        }
        
        XCTAssertEqual(item.id, "12345")
        XCTAssertEqual(item.text, "Минимальная задача")
        XCTAssertEqual(item.isDone, false)
        XCTAssertEqual(item.creationDate, date)
        XCTAssertEqual(item.importance, .medium)
        XCTAssertNil(item.deadline)
        XCTAssertNil(item.modificationDate)
    }
}
