//
//  URLSessionErrorsTests.swift
//  DailyDeedsTests
//
//  Created by Дмитрий Корчагин on 7/9/24.
//

import XCTest
import Foundation
@testable import DailyDeeds

class URLSessionTests: XCTestCase {
    
    var session: URLSession!
    
    override func setUp() {
        super.setUp()
        
        let configuration = URLSessionConfiguration.ephemeral
        configuration.protocolClasses = [MockURLProtocol.self]
        session = URLSession(configuration: configuration)
    }
    
    override func tearDown() {
        session = nil
        super.tearDown()
    }
    
    func testDataTaskCancellation() async {
        let url = URL(string: "https://example.com/todos/1")!
        let urlRequest = URLRequest(url: url)
        
        MockURLProtocol.requestHandler = { request in
            // Имитируем успешный ответ
            let response = HTTPURLResponse(url: request.url!, statusCode: 200, httpVersion: nil, headerFields: nil)!
            return (response, nil)
        }
        
        let task = Task {
            do {
                let (_, response) = try await self.session.dataTask(for: urlRequest)
                XCTFail("Expected task to be cancelled, but it succeeded with response: \(response)")
            } catch {
                XCTAssertTrue((error as NSError).code == NSUserCancelledError, "Expected cancellation error, got \(error)")
            }
        }
        
        // Отмена задачи почти сразу
        task.cancel()
        
        // Даем немного времени для того, чтобы отмена успела сработать
        try? await Task.sleep(nanoseconds: 500_000_000) // 0.5 секунда
        
        await task.value
    }
}

final class MockURLProtocol: URLProtocol {
    static var requestHandler: ((URLRequest) throws -> (HTTPURLResponse, Data?))?
    
    override class func canInit(with request: URLRequest) -> Bool {
        return true
    }
    
    override class func canonicalRequest(for request: URLRequest) -> URLRequest {
        return request
    }
    
    override func startLoading() {
        guard let handler = MockURLProtocol.requestHandler else {
            fatalError("Request handler is not set.")
        }
        
        DispatchQueue.global().asyncAfter(deadline: .now() + 1) { [weak self] in
            guard let self = self else { return }
            
            do {
                if Task.isCancelled {
                    self.client?.urlProtocol(self, didFailWithError: URLError(.cancelled))
                    return
                }
                
                let (response, data) = try handler(self.request)
                self.client?.urlProtocol(self, didReceive: response, cacheStoragePolicy: .notAllowed)
                
                if let data = data {
                    self.client?.urlProtocol(self, didLoad: data)
                }
                
                self.client?.urlProtocolDidFinishLoading(self)
            } catch {
                self.client?.urlProtocol(self, didFailWithError: error)
            }
        }
    }
    
    override func stopLoading() { }
}
