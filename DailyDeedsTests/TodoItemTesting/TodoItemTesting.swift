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
            importance: .medium,
            isDone: false,
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
        let csvString = "3,Finish Project,обычная,true,2021-06-15 12:10:00,2021-06-15 12:10:00,"

        guard let item = TodoItem.parse(csv: csvString) else {
            Issue.record("cant parsing csv file")
            return
        }

        #expect(item.id == "3")
        #expect(item.text == "Finish Project")
        #expect(item.importance == .medium)
        #expect(item.isDone)
        #expect(item.creationDate != nil)
        #expect(item.deadline != nil)
        #expect(item.modificationDate == nil)
    }
}
