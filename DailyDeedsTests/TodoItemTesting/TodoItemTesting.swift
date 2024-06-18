//
//  TodoItemTesting.swift
//  DailyDeedsTests
//
//  Created by Дмитрий Корчагин on 6/14/24.
//

import Testing
import Foundation
@testable import DailyDeeds

struct TodoItemTesting {

    @Test func testInit() {
        let item = TodoItem(
            id: "1",
            text: "Test Task",
            isDone: false,
            importance: .medium,
            creationDate: Date(),
            deadline: nil,
            modificationDate: nil
        )
        #expect(item.id == "1")
        #expect(item.text == "Test Task")
        #expect(item.importance == .medium)
        #expect(item.deadline == nil)
        #expect(!item.isDone)
        #expect(item.creationDate != nil)
        #expect(item.modificationDate == nil)
    }
    
    @Test func testCSVParsing() {
        let csvString = "3,Finish Project with deadline,true,обычная,2021-06-15 12:10:00,2021-06-15 12:10:00,"

        guard let item = TodoItem.parse(csv: csvString) else {
            Issue.record("cant parsing csv file")
            return
        }

        #expect(item.id == "3")
        #expect(item.text == "Finish Project with deadline")
        #expect(item.importance == .medium)
        #expect(item.isDone)
        #expect(item.creationDate != nil)
        #expect(item.deadline != nil)
        #expect(item.modificationDate == nil)
    }
    
    @Test func testCSVParsing2() {
        let csvString = "3,Finish Project without deadline,true,обычная,2021-06-15 12:10:00,,2021-06-15 12:10:00,"

        guard let item = TodoItem.parse(csv: csvString) else {
            Issue.record("cant parsing csv file test2")
            return
        }

        #expect(item.id == "3")
        #expect(item.text == "Finish Project without deadline")
        #expect(item.importance == .medium)
        #expect(item.isDone)
        #expect(item.creationDate != nil)
        #expect(item.deadline == nil)
        #expect(item.modificationDate != nil)
    }
    
    @Test func testCSVParsing3() {
        let csvString = "3,Finish Project without other info,true,обычная,2021-06-15 12:10:00,,"

        guard let item = TodoItem.parse(csv: csvString) else {
            Issue.record("cant parsing csv file test3")
            return
        }

        #expect(item.id == "3")
        #expect(item.text == "Finish Project without other info")
        #expect(item.importance == .medium)
        #expect(item.isDone)
        #expect(item.creationDate == "2021-06-15 12:10:00".toDate())
        #expect(item.deadline == nil)
        #expect(item.modificationDate == nil)
    }
}
