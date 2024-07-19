//
//  APIEndpoint.swift
//  DailyDeeds
//
//  Created by Дмитрий Корчагин on 7/16/24.
//

import FileCache
import Foundation
import URL

enum APIEndpoint {
    private static let baseURL = #URL("https://hive.mrdekk.ru/todo")
    private static let listPathComponent = "list"
    private static let token = "<token>"
    private static let threshold = 50
    
    case fetchTodoList
    case updateTodoList(revision: Int)
    case fetchTodoItem(id: String)
    case createTodoItem(revision: Int)
    case updateTodoItem(id: String, revision: Int)
    case deleteTodoItem(id: String, revision: Int)
    
    var url: URL {
        let url = APIEndpoint.baseURL.appendingPathComponent(APIEndpoint.listPathComponent)
        switch self {
        case .fetchTodoList, .createTodoItem, .updateTodoList:
            return url
        case .fetchTodoItem(let id), .deleteTodoItem(let id, _), .updateTodoItem(let id, _):
            return url.appendingPathComponent("\(id)")
        }
    }
    
    var method: String {
        switch self {
        case .fetchTodoList, .fetchTodoItem:
            return "GET"
        case .updateTodoList:
            return "PATCH"
        case .createTodoItem:
            return "POST"
        case .updateTodoItem:
            return "PUT"
        case .deleteTodoItem:
            return "DELETE"
        }
    }
    
    var headers: [String: String] {
        switch self {
        case .fetchTodoList, .fetchTodoItem:
            return ["Authorization": "Bearer \(APIEndpoint.token)"]
        case .updateTodoList(let revision),
                .createTodoItem(let revision),
                .updateTodoItem(_, let revision),
                .deleteTodoItem(_, let revision):
            return [
                "Authorization": "Bearer \(APIEndpoint.token)",
                "X-Last-Known-Revision": "\(revision)"
            ]
        }
    }
    
    func request(
        withBody body: (any ITodoResponse & JSONParsable)? = nil,
        generateErrors: Bool = false
    ) throws -> URLRequest {
        var request = URLRequest(url: url)
        request.httpMethod = method
        request.allHTTPHeaderFields = headers
        
        if let body = body {
            request.httpBody = try JSONSerialization.data(withJSONObject: body.json)
        }
        
        if generateErrors {
            request.setValue("\(APIEndpoint.threshold)", forHTTPHeaderField: "X-Generate-Fails")
        }
        
        return request
    }
}
