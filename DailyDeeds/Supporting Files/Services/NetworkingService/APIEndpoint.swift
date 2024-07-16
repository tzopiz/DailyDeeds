//
//  APIEndpoint.swift
//  DailyDeeds
//
//  Created by Дмитрий Корчагин on 7/16/24.
//

import Foundation
import CocoaLumberjackSwift

enum APIEndpoint {
    // TODO: Macros
    private static let baseURL = URL(string: "https://beta.mrdekk.ru/todo")!
    private static let listPathComponent = "list"
    private static let token = "token"
    private static let threshold = 50
    
    case fetchTodoList
    case updateTodoList(revision: Int)
    case fetchTodoItem(id: String)
    case createTodoItem(revision: Int)
    case updateTodoItem(id: String)
    case deleteTodoItem(id: String)
    
    var url: URL {
        switch self {
        case .fetchTodoList:
            return APIEndpoint.baseURL.appendingPathComponent(APIEndpoint.listPathComponent)
            
        case .updateTodoList(let revision), .createTodoItem(let revision):
            let url = APIEndpoint.baseURL.appendingPathComponent(APIEndpoint.listPathComponent)
            return url.appending(queryItems: [URLQueryItem(name: "revision", value: "\(revision)")])
            
        case .fetchTodoItem(let id), .deleteTodoItem(let id), .updateTodoItem(let id):
            return APIEndpoint.baseURL.appendingPathComponent("\(APIEndpoint.listPathComponent)/\(id)")
        }
    }
    
    var method: String {
        switch self {
        case .fetchTodoList, .fetchTodoItem:
            return "GET"
        case .updateTodoList, .updateTodoItem:
            return "PUT"
        case .createTodoItem:
            return "POST"
        case .deleteTodoItem:
            return "DELETE"
        }
    }
    
    var headers: [String: String] {
        // TODO: -
        // Authorization: OAuth <oauth_token>
        // X-Generate-Fails: <threshold>
        switch self {
        case .fetchTodoList, .fetchTodoItem, .deleteTodoItem, .updateTodoItem:
            return ["Authorization": "Bearer <\(APIEndpoint.token)>"]
        case .updateTodoList(let revision), .createTodoItem(let revision):
            return [
                "Authorization": "Bearer <\(APIEndpoint.token)>",
                "X-Last-Known-Revision": "\(revision)"
            ]
        }
    }
    
    func request(withBody body: JSONDictionary? = nil, generateFails: Bool = false) throws -> URLRequest {
        var request = URLRequest(url: url)
        request.httpMethod = method
        request.allHTTPHeaderFields = headers
        
        if let body = body {
            do {
                request.httpBody = try JSONSerialization.data(withJSONObject: body)
            } catch {
                let message = DDLogMessageFormat(stringLiteral: error.localizedDescription)
                DDLogError(message)
            }
        }
        
        if generateFails {
            var headers = headers
            headers["X-Generate-Fails"] = "\(APIEndpoint.threshold)"
            request.allHTTPHeaderFields = headers
        }
        
        return request
    }
}
