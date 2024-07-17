//
//  APIEndpoint.swift
//  DailyDeeds
//
//  Created by Дмитрий Корчагин on 7/16/24.
//

import CocoaLumberjackSwift
import FileCache
import Foundation
import URL

enum APIEndpoint {
    private static let baseURL = #URL("https://hive.mrdekk.ru/todo")
    private static let listPathComponent = "list"
    private static let token = "Bearer Bereg"
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
            return ["Authorization": APIEndpoint.token]
        case .updateTodoList(let revision),
                .createTodoItem(let revision),
                .updateTodoItem(_, let revision),
                .deleteTodoItem(_, let revision):
            return [
                "Authorization": APIEndpoint.token,
                "X-Last-Known-Revision": "\(revision)"
            ]
        }
    }
    
    func request(withBody body: Any? = nil, generateErrors: Bool = false) throws -> URLRequest {
        var request = URLRequest(url: url)
        request.httpMethod = method
        request.allHTTPHeaderFields = headers
        
        if let body = body {
            do {
                if let dictionaryBody = body as? JSONDictionary {
                    request.httpBody = try JSONSerialization.data(withJSONObject: dictionaryBody)
                } else if let arrayBody = body as? [JSONDictionary] {
                    request.httpBody = try JSONSerialization.data(withJSONObject: arrayBody)
                } else {
                    throw NetworkingError.invalidBodyType
                }
            } catch {
                let message = DDLogMessageFormat(
                    stringLiteral: "APIEndpoint.\(#function):" + error.localizedDescription
                )
                DDLogError(message)
            }
        }
        
        if generateErrors {
            request.setValue("\(APIEndpoint.threshold)", forHTTPHeaderField: "X-Generate-Fails")
        }
        
        return request
    }
}
