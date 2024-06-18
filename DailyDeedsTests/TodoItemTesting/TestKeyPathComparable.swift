//
//  TestKeyPathComparable.swift
//  DailyDeedsTests
//
//  Created by Дмитрий Корчагин on 6/14/24.
//

import XCTest
@testable import DailyDeeds

final class TestKeyPathComparable: XCTestCase {

    func testSortingByIdKeyPath() {
        let item1 = TodoItem(id: "2", text: "Задача 1", importance: .medium)
        let item2 = TodoItem(id: "1", text: "Задача 2", importance: .high)
        let item3 = TodoItem(id: "3", text: "Задача 3", importance: .low)
        
        let unsortedItems = [item3, item1, item2]
        let sortedItems = unsortedItems.sorted(by: \TodoItem.id)
        
        XCTAssertEqual(sortedItems, [item2, item1, item3])
    }
    
    func testSortingByTextKeyPath() {
        let item1 = TodoItem(id: "1", text: "Задача 2", importance: .medium)
        let item2 = TodoItem(id: "2", text: "Задача 1", importance: .high)
        let item3 = TodoItem(id: "3", text: "Задача 3", importance: .low)
        
        let unsortedItems = [item3, item1, item2]
        let sortedItems = unsortedItems.sorted(by: \TodoItem.text)
        
        XCTAssertEqual(sortedItems, [item2, item1, item3])
    }
    
    func testSortingByImportanceKeyPath() {
        let item1 = TodoItem(id: "1", text: "Задача 1", importance: .medium)
        let item2 = TodoItem(id: "2", text: "Задача 2", importance: .high)
        let item3 = TodoItem(id: "3", text: "Задача 3", importance: .low)
        
        let unsortedItems = [item1, item2, item3]
        let sortedItems = unsortedItems.sorted(by: \TodoItem.importance, ascending: false)
        
        XCTAssertEqual(sortedItems, [item2, item1, item3])
    }
    
    func testSortByImportanceKeyPath() {
        let item1 = TodoItem(id: "1", text: "Задача 1", importance: .medium)
        let item2 = TodoItem(id: "2", text: "Задача 2", importance: .high)
        let item3 = TodoItem(id: "3", text: "Задача 3", importance: .low)
        
        var unsortedItems = [item1, item2, item3]
        unsortedItems.sort(by: \TodoItem.importance)
        
        XCTAssertEqual(unsortedItems, [item3, item1, item2])
    }
    
    func testFilterByImportanceKeyPath() {
        let item1 = TodoItem(id: "1", text: "Задача 1", importance: .medium)
        let item2 = TodoItem(id: "2", text: "Задача 2", importance: .high)
        let item3 = TodoItem(id: "3", text: "Задача 3", importance: .low)
        
        let unsortedItems = [item1, item2, item3]
        let filteredItems = unsortedItems.filter(by: \.deadline, predicate: { $0 != nil} )
        
        XCTAssertEqual(filteredItems.count, 0)
    }
}
