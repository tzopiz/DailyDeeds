//
//  DefaultNetworkingService.swift
//  DailyDeeds
//
//  Created by Дмитрий Корчагин on 7/16/24.
//

import Foundation

class DefaultNetworkingService: INetworkingService {
    enum NetworkingError: Error {
        case invalidResponse
        case httpError(statusCode: Int)
        case requestTimeout
        case noInternetConnection
        case serverError
        case parsingError
        case unknown
    }
    
    private let session: URLSession
    
    init(session: URLSession = URLSession(configuration: .default)) {
        self.session = session
    }
}

// MARK: - GET Requests
extension DefaultNetworkingService {
    func fetchTodoList() async throws -> TodoListResponse {
        let request = try APIEndpoint.fetchTodoList.request()
        return try await performRequest(for: request)
    }
    
    func fetchTodoItem(id: String) async throws -> TodoItemResponse {
        let request = try APIEndpoint.fetchTodoItem(id: id).request()
        return try await performRequest(for: request)
    }
}

// MARK: - PUT Requests
extension DefaultNetworkingService {
    func updateTodoList(patchData: JSONDictionary, revision: Int) async throws -> TodoListResponse {
        let request = try APIEndpoint.updateTodoList(revision: revision).request(withBody: patchData)
        return try await performRequest(for: request)
    }
    
    func updateTodoItem(id: String, data: JSONDictionary) async throws -> TodoItemResponse {
        let request = try APIEndpoint.updateTodoItem(id: id).request(withBody: data)
        return try await performRequest(for: request)
    }
}

// MARK: - POST Requests
extension DefaultNetworkingService {
    func createTodoItem(data: JSONDictionary, revision: Int) async throws -> TodoItemResponse {
        let request = try APIEndpoint.createTodoItem(revision: revision).request(withBody: data)
        return try await performRequest(for: request)
    }
}

// MARK: - DELETE Requests
extension DefaultNetworkingService {
    func deleteTodoItem(id: String) async throws -> TodoItemResponse {
        let request = try APIEndpoint.deleteTodoItem(id: id).request()
        return try await performRequest(for: request)
    }
}

// MARK: - Request Methods
extension DefaultNetworkingService {
    private func performRequest<T: JSONParsable>(for request: URLRequest) async throws -> T {
        do {
            let (data, response) = try await session.data(for: request)
            try checkResponseStatus(response)
            
            let jsonObject = try await Task.detached {
                try JSONSerialization.jsonObject(with: data) as? T.JSONType
            }.value
            
            guard let json = jsonObject, let parsedObject = T.parse(json: json) else {
                throw NetworkingError.parsingError
            }
            
            return parsedObject
        } catch let error as URLError {
            switch error.code {
            case .notConnectedToInternet:
                throw NetworkingError.noInternetConnection
            case .timedOut:
                throw NetworkingError.requestTimeout
            default:
                throw NetworkingError.unknown
            }
        } catch {
            throw NetworkingError.unknown
        }
    }
    
    private func checkResponseStatus(_ response: URLResponse?) throws {
        
        guard let httpResponse = response as? HTTPURLResponse else {
            throw NetworkingError.invalidResponse
        }
        
        switch httpResponse.statusCode {
        case 200...299:
            return
        case 400...499:
            throw NetworkingError.httpError(statusCode: httpResponse.statusCode)
        case 500...599:
            throw NetworkingError.serverError
        default:
            throw NetworkingError.unknown
        }
    }
}
