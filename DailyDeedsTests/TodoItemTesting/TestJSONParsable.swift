//
//  TestJSONParsable.swift
//  DailyDeedsTests
//
//  Created by Дмитрий Корчагин on 6/15/24.
//

@testable import DailyDeeds
import XCTest

final class TestJSONParsable: XCTestCase {
    typealias Keys = TodoItem.CodingKeys
    private let creationDate = Date(timeIntervalSince1970: TimeInterval(1674990000))
    private let deadline = Date(timeIntervalSince1970: TimeInterval(1675000000))
    private let modificationDate = Date(timeIntervalSince1970: TimeInterval(1674991000))

    func testParseJSON() {
        let id = "1"
        let text = "Задача из JSON"
        let isDone = true
        let importance = Importance.high
        let hexColor = "#FFFFFF"
        let json = TodoItem.buildJSONDictionary {
            (Keys.id, id)
            (Keys.text, text)
            (Keys.isDone, isDone)
            (Keys.importance, importance)
            (Keys.hexColor, hexColor)
            (Keys.creationDate, creationDate)
            (Keys.deadline, deadline)
            (Keys.lastUpdatedDevice, "")
            (Keys.modificationDate, modificationDate)
            (Keys.category, Category.defaultCategory)
        }

        guard let item = TodoItem.parse(json: json) else {
            XCTFail("Failed to parse JSON into TodoItem")
            return
        }

        XCTAssertEqual(item.id, id)
        XCTAssertEqual(item.text, text)
        XCTAssertEqual(item.importance, importance)
        XCTAssertEqual(item.isDone, isDone)
        XCTAssertEqual(item.creationDate, creationDate)
        XCTAssertEqual(item.deadline, deadline)
        XCTAssertEqual(item.modificationDate, modificationDate)
    }

    func testJSONRepresentation() {
        let id = "1"
        let text = "Задача из JSON"
        let isDone = false
        let importance = Importance.medium
        let item = TodoItem(
            id: id,
            text: text,
            isDone: isDone,
            creationDate: creationDate,
            importance: importance,
            modificationDate: modificationDate,
            deadline: deadline
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
        XCTAssertEqual(item.deadline, parsedItem.deadline)
        XCTAssertEqual(item.modificationDate, parsedItem.modificationDate)

    }

    func testFromJSONString() {
        let id = "789"
        let text = "Еще одна задача из JSON строка"
        let isDone = true
        let hexColor = "#FFFFFF"
        let _item = TodoItem(
            id: id,
            text: text,
            isDone: isDone,
            hexColor: hexColor, creationDate: creationDate,
            importance: .medium,
            modificationDate: modificationDate,
            deadline: deadline
        )
        guard let str = _item.jsonString, let item = TodoItem.from(jsonString: str) else {
            XCTFail("Failed to parse JSON string into TodoItem")
            return
        }

        XCTAssertEqual(item.id, id)
        XCTAssertEqual(item.text, text)
        XCTAssertEqual(item.isDone, isDone)
        XCTAssertEqual(item.importance, .medium)
        XCTAssertEqual(item.creationDate, creationDate)
        XCTAssertEqual(item.deadline, deadline)
        XCTAssertEqual(item.modificationDate, modificationDate)
    }

    func testMinimalJSON() {
        let id = "1"
        let text = "Задача из JSON"
        let isDone = true
        let hexColor = "#FFFFFF"
        let importance = Importance.high
        let device = "123"
        let json = TodoItem.buildJSONDictionary {
            (Keys.id, id)
            (Keys.text, text)
            (Keys.isDone, isDone)
            (Keys.importance, importance)
            (Keys.hexColor, hexColor)
            (Keys.creationDate, creationDate)
            (Keys.modificationDate, creationDate)
            (Keys.lastUpdatedDevice, device)
            (Keys.category, Category.defaultCategory)
        }

        guard let item = TodoItem.parse(json: json) else {
            XCTFail("Failed to parse minimal JSON into TodoItem")
            return
        }

        XCTAssertEqual(item.id, id)
        XCTAssertEqual(item.text, text)
        XCTAssertEqual(item.isDone, isDone)
        XCTAssertEqual(item.importance, importance)
        XCTAssertEqual(item.creationDate, creationDate)
        XCTAssertNil(item.deadline)
        XCTAssertEqual(item.modificationDate, creationDate)
        XCTAssertEqual(item.lastUpdatedDevice, device)
    }
}
