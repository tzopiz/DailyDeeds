//
//  TestKeyPathComparable.swift
//  DailyDeedsTests
//
//  Created by Дмитрий Корчагин on 6/14/24.
//

import XCTest
@testable import DailyDeeds

final class TestKeyPathComparable: XCTestCase {

    private let item1 = TodoItem(
        id: "1", text: "Задача 1",
        isDone: false, importance: .low,
        creationDate: .now
    )
    private let item2 = TodoItem(
        id: "2", text: "Задача 2",
        isDone: true, importance: .medium,
        creationDate: .now
    )
    private let item3 = TodoItem(
        id: "3", text: "Задача 3",
        isDone: false, importance: .high,
        creationDate: .now
    )

    func testSortingByIdKeyPath() {

        let unsortedItems = [item2, item1, item3]
        let sortedItems = unsortedItems.sorted(by: \.id)

        XCTAssertEqual(sortedItems, [item1, item2, item3])
    }

    func testSortingByImportanceKeyPath() {

        let unsortedItems = [item2, item1, item3]
        let sortedItems = unsortedItems.sorted(by: \.importance, ascending: false)

        XCTAssertEqual(sortedItems, [item3, item2, item1])
    }

    func testFilterByImportanceKeyPath() {
        let unsortedItems = [item1, item2, item3]
        let filteredItems = unsortedItems.filter(by: \.deadline, predicate: { $0 != nil})

        XCTAssertEqual(filteredItems.count, 0)
    }
}
