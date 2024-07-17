//
//  URLSessionMock.swift
//  DailyDeedsTests
//
//  Created by Дмитрий Корчагин on 7/17/24.
//

import CocoaLumberjackSwift
import Foundation

class MockURLProtocol: URLProtocol {
    static var error: Error?
    static var delayTime: TimeInterval = 5 // Длительность задержки в секундах
    static var requestHandler: ((URLRequest) throws -> (HTTPURLResponse, Data))?
    
    override class func canInit(with request: URLRequest) -> Bool {
        return true
    }
    
    override class func canonicalRequest(for request: URLRequest) -> URLRequest {
        return request
    }
    
    override func startLoading() {
        if let error = MockURLProtocol.error {
            client?.urlProtocol(self, didFailWithError: error)
            return
        }
        
        guard let handler = MockURLProtocol.requestHandler else {
            assertionFailure("Received unexpected request with no handler set")
            return
        }
        
        DispatchQueue.global().asyncAfter(deadline: .now() + MockURLProtocol.delayTime) {
            do {
                let (response, data) = try handler(self.request)
                self.client?.urlProtocol(self, didReceive: response, cacheStoragePolicy: .notAllowed)
                self.client?.urlProtocol(self, didLoad: data)
                self.client?.urlProtocolDidFinishLoading(self)
            } catch {
                self.client?.urlProtocol(self, didFailWithError: error)
            }
        }
    }
    
    override func stopLoading() {
        DDLogVerbose("Function stopLoading in DelayedURLProtocol called")
    }
}
