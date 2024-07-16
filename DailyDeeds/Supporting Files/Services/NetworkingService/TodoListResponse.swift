//
//  TodoListResponse.swift
//  DailyDeeds
//
//  Created by Дмитрий Корчагин on 7/16/24.
//

import Foundation
import FileCache

struct TodoListResponse {
    let status: String
    let list: [TodoItem]
    let revision: Int
    enum CodingKeys {
        static let status = "status"
        static let list = "list"
        static let revision = "revision"
    }
}

// MARK: - JSONParsable
extension TodoListResponse: JSONParsable {
    var json: JSONDictionary {
        TodoListResponse.buildJSON {
            (CodingKeys.status, status)
            (CodingKeys.list, list)
            (CodingKeys.revision, revision)
        }
    }
    
    static func parse(json: JSONDictionary) -> TodoListResponse? {
        guard let status = json[CodingKeys.status] as? String,
              let listJson = json[CodingKeys.list] as? [JSONDictionary],
              let revision = json[CodingKeys.revision] as? Int else {
            return nil
        }
        
        let list = listJson.compactMap { TodoItem.parse(json: $0) }
        return TodoListResponse(status: status, list: list, revision: revision)
    }
}

// MARK: -
extension JSONBuilder {
    static func buildExpression(_ expression: (key: String, value: [TodoItem])) -> JSONDictionary {
        return [expression.key: expression.value.compactMap { $0.json }]
    }
}
