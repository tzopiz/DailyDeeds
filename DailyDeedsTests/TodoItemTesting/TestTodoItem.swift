//
//  TodoItemUnitTest.swift
//  DailyDeedsTests
//
//  Created by Дмитрий Корчагин on 6/14/24.
//

import XCTest
@testable import DailyDeeds

class TodoItemTests: XCTestCase {
    
    func testInitialization() {
        let text = "Новая задача"
        let importance = Importance.medium
        let creationDate = Date()
        
        let item = TodoItem(text: text, importance: importance, creationDate: creationDate)
        
        XCTAssertEqual(item.text, text)
        XCTAssertEqual(item.importance, importance)
        XCTAssertFalse(item.isDone)
        XCTAssertEqual(item.creationDate, creationDate)
        XCTAssertNil(item.deadline)
        XCTAssertNil(item.modificationDate)
    }
    
    func testDescription() {
        let creationDate = Date()
        let item = TodoItem(
            id: "123",
            text: "Задача для тестирования",
            importance: .high,
            creationDate: creationDate
        )
        
        let expectedDescription = """
            TodoItem(id: 123,
            \ttext: "Задача для тестирования",
            \timportance: важная,
            \tisDone: false,
            \tcreationDate: \(creationDate.toString()),
            \tdeadline: ,
            \tmodificationDate: )
            """
        
        XCTAssertEqual(item.description, expectedDescription)
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
    
    func testTaskUpdate() {
        var item = TodoItem(id: "123", text: "Задача для обновления", importance: .medium)
        
        XCTAssertFalse(item.isDone)
        
        item.isDone = true
        item.modificationDate = Date()
        
        XCTAssertTrue(item.isDone)
        XCTAssertNotNil(item.modificationDate)
    }
}

