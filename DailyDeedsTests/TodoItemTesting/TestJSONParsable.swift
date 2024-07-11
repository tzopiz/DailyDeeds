//
//  TestJSONParsable.swift
//  DailyDeedsTests
//
//  Created by Дмитрий Корчагин on 6/15/24.
//

import XCTest
@testable import DailyDeeds

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
        let json = TodoItem.buildJSON {
            (Keys.id, id)
            (Keys.text, text)
            (Keys.isDone, isDone)
            (Keys.importance, importance)
            (Keys.hexColor, hexColor)
            (Keys.creationDate, creationDate)
            (Keys.deadline, deadline)
            (Keys.modificationDate, modificationDate)
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
            id: id, text: text, isDone: isDone,
            importance: importance,
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
        XCTAssertEqual(item.deadline, parsedItem.deadline)
        XCTAssertEqual(item.modificationDate, parsedItem.modificationDate)

    }

    func testFromJSONString() {
        let id = "789"
        let text = "Еще одна задача из JSON строка"
        let isDone = true
        let hexColor = "#FFFFFF"
        let jsonString = """
            {
                "\(Keys.id)": "\(id)",
                "\(Keys.text)": "\(text)",
                "\(Keys.isDone)": \(isDone),
                "\(Keys.deadline)": "\(deadline.toString())",
                "\(Keys.hexColor)": "\(hexColor)",
                "\(Keys.creationDate)": "\(creationDate.toString())",
                "\(Keys.modificationDate)": "\(modificationDate.toString())"
            }
            """

        guard let item = TodoItem.from(jsonString: jsonString) else {
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
        let json = TodoItem.buildJSON {
            (Keys.id, id)
            (Keys.text, text)
            (Keys.isDone, isDone)
            (Keys.importance, importance)
            (Keys.hexColor, hexColor)
            (Keys.creationDate, creationDate)
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
        XCTAssertNil(item.modificationDate)
    }
}
