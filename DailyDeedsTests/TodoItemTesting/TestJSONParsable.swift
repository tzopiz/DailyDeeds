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
        let json: [String: Any] = [
            "id": "123",
            "text": "Задача из JSON",
            "importance": "важная",
            "isDone": true,
            "creationDate": TimeInterval(1674990000),
            "deadline": TimeInterval(1675000000),
            "modificationDate": TimeInterval(1674991000)
        ]
        
        guard let item = TodoItem.parse(json: json) else {
            XCTFail("Failed to parse JSON into TodoItem")
            return
        }
        
        XCTAssertEqual(item.id, "123")
        XCTAssertEqual(item.text, "Задача из JSON")
        XCTAssertEqual(item.importance, .high)
        XCTAssertEqual(item.isDone, true)
        XCTAssertEqual(item.creationDate.timeIntervalSince1970, 1674990000)
        XCTAssertEqual(item.deadline?.timeIntervalSince1970, 1675000000)
        XCTAssertEqual(item.modificationDate?.timeIntervalSince1970, 1674991000)
    }
    
    func testJSONRepresentation() {
        let creationDate = Date(timeIntervalSince1970: 1674990000)
        let modificationDate = Date(timeIntervalSince1970: 1674991000)
        let deadline = Date(timeIntervalSince1970: 1675000000)
        
        let item = TodoItem(
            id: "456",
            text: "Еще одна задача из JSON",
            importance: .low,
            isDone: false,
            creationDate: creationDate,
            deadline: deadline,
            modificationDate: modificationDate
        )
        
        let expectedJSON: [String: Any] = [
            "id": "456",
            "text": "Еще одна задача из JSON",
            "importance": "неважная",
            "isDone": false,
            "creationDate": creationDate.timeIntervalSince1970,
            "deadline": deadline.timeIntervalSince1970,
            "modificationDate": modificationDate.timeIntervalSince1970
        ]
        
        XCTAssertTrue(dictionariesAreEqual(item.json, expectedJSON))
    }
    func testFromJSONString() {
        let jsonString = """
            {
                "id": "789",
                "text": "Еще одна задача из JSON строка",
                "importance": "обычная",
                "isDone": true,
                "creationDate": 1675990000,
                "deadline": 1676000000,
                "modificationDate": 1675991000
            }
            """
        
        guard let item = TodoItem.from(jsonString: jsonString) else {
            XCTFail("Failed to parse JSON string into TodoItem")
            return
        }
        
        XCTAssertEqual(item.id, "789")
        XCTAssertEqual(item.text, "Еще одна задача из JSON строка")
        XCTAssertEqual(item.importance, .medium)
        XCTAssertEqual(item.isDone, true)
        XCTAssertEqual(item.creationDate.timeIntervalSince1970, 1675990000)
        XCTAssertEqual(item.deadline?.timeIntervalSince1970, 1676000000)
        XCTAssertEqual(item.modificationDate?.timeIntervalSince1970, 1675991000)
    }
    private func dictionariesAreEqual(_ dict1: [String: Any], _ dict2: [String: Any]) -> Bool {
        // Проверяем количество ключей
        guard dict1.count == dict2.count else {
            return false
        }
        
        // Проверяем каждую пару ключ-значение
        for (key, value1) in dict1 {
            guard let value2 = dict2[key] else { return false }
            
            // Сравниваем значения
            if let nestedDict1 = value1 as? [String: Any], let nestedDict2 = value2 as? [String: Any] {
                // Если значение является словарем, рекурсивно проверяем его равенство
                if !dictionariesAreEqual(nestedDict1, nestedDict2) { return false }
            } else if let array1 = value1 as? [Any], let array2 = value2 as? [Any] {
                // Если значение является массивом, сравниваем массивы
                if !arraysAreEqual(array1, array2) { return false }
            } else if let value1 = value1 as? AnyHashable, let value2 = value2 as? AnyHashable {
                // Используем AnyHashable для сравнения значений
                if value1 != value2 { return false }
            } else { return false }
        }
        return true
    }

    // Вспомогательная функция для сравнения массивов
    private func arraysAreEqual(_ array1: [Any], _ array2: [Any]) -> Bool {
        guard array1.count == array2.count else {
            return false
        }
        
        for (index, value1) in array1.enumerated() {
            let value2 = array2[index]
            
            if let nestedArray1 = value1 as? [Any], let nestedArray2 = value2 as? [Any] {
                if !arraysAreEqual(nestedArray1, nestedArray2) {
                    return false
                }
            } else if let value1 = value1 as? AnyHashable, let value2 = value2 as? AnyHashable {
                if value1 != value2 { return false }
            } else { return false }
        }
        return true
    }

}
