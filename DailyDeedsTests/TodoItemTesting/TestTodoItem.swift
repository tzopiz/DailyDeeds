//
//  TodoItemUnitTest.swift
//  DailyDeedsTests
//
//  Created by Дмитрий Корчагин on 6/14/24.
//

@testable import DailyDeeds
import XCTest

final class TodoItemTests: XCTestCase {

    func testInitialization() {
        let text = "Новая задача"
        let importance = Importance.medium
        let isDone = false
        let creationDate = Date()

        let item = TodoItem(
            text: text,
            isDone: isDone,
            creationDate: creationDate,
            importance: importance,
            modificationDate: creationDate
        )

        XCTAssertEqual(item.text, text)
        XCTAssertEqual(item.importance, importance)
        XCTAssertEqual(item.isDone, isDone)
        XCTAssertEqual(item.creationDate, creationDate)
        XCTAssertNil(item.deadline)
        XCTAssertEqual(item.modificationDate, creationDate)
    }

    func testDateConversion() {
        let dateString = "2023-06-14 12:00:00"
        let expectedDate = dateString.toDate()
        let formattedString = expectedDate.toString()

        XCTAssertEqual(formattedString, dateString)
    }

    func testImportanceComparison() {
        let low = Importance.low
        let medium = Importance.medium
        let high = Importance.high

        XCTAssertLessThan(low, medium)
        XCTAssertLessThan(medium, high)
        XCTAssertGreaterThan(high, low)
    }
}
