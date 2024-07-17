//
//  TodoListResponse.swift
//  DailyDeeds
//
//  Created by Дмитрий Корчагин on 7/16/24.
//

import FileCache
import Foundation

struct TodoListResponse: ITodoResponse {
    let status: String
    let result: [TodoItem]
    let revision: Int
    enum CodingKeys {
        static let status = "status"
        static let result = "list"
        static let revision = "revision"
    }
}

// MARK: - JSONParsable
extension TodoListResponse: JSONParsable {
    var json: JSONDictionary {
        TodoListResponse.buildJSONDictionary {
            (CodingKeys.status, status)
            (CodingKeys.result, result)
            (CodingKeys.revision, revision)
        }
    }
    
    static func parse(json: JSONDictionary) -> TodoListResponse? {
        guard let status = json[CodingKeys.status] as? String,
              let listJson = json[CodingKeys.result] as? [JSONDictionary],
              let revision = json[CodingKeys.revision] as? Int else {
            return nil
        }
        
        let list = listJson.compactMap { TodoItem.parse(json: $0) }
        return TodoListResponse(status: status, result: list, revision: revision)
    }
}

// MARK: -
extension JSONBuilder {
    static func buildExpression(_ expression: (key: String, value: [TodoItem])) -> JSONDictionary {
        return [expression.key: expression.value.compactMap { $0.json }]
    }
}
