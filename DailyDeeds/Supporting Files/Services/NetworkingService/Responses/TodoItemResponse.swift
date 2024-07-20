//
//  TodoItemResponse.swift
//  DailyDeeds
//
//  Created by Дмитрий Корчагин on 7/16/24.
//

import FileCache
import Foundation

struct TodoItemResponse: ITodoResponse {
    let status: String
    let result: TodoItem?
    let revision: Int
    enum CodingKeys {
        static let status = "status"
        static let result = "element"
        static let revision = "revision"
    }
}

// MARK: - JSONParsable
extension TodoItemResponse: JSONParsable {
    var json: JSONDictionary {
        TodoItemResponse.buildJSONDictionary {
            (CodingKeys.status, status)
            (CodingKeys.result, result)
            (CodingKeys.revision, revision)
        }
    }
    
    static func parse(json: JSONDictionary) -> TodoItemResponse? {
        guard let status = json[CodingKeys.status] as? String,
              let elementJson = json[CodingKeys.result] as? JSONDictionary,
              let revision = json[CodingKeys.revision] as? Int
        else { return nil }
        
        let element = TodoItem.parse(json: elementJson)
        
        return TodoItemResponse(status: status, result: element, revision: revision)
    }
}

// MARK: -
extension JSONBuilder {
    static func buildExpression(_ expression: (key: String, value: TodoItem?)) -> JSONDictionary {
        guard let jsonValue = expression.value?.json else { return [:] }
        return [expression.key: jsonValue]
    }
    
    static func buildExpression(_ expression: (key: String, value: Int?)) -> JSONDictionary {
        guard let value = expression.value else { return [:] }
        return [expression.key: value]
    }
}
