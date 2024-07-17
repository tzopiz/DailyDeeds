//
//  MockURLProtocol.swift
//  DailyDeeds
//
//  Created by Дмитрий Корчагин on 7/16/24.
//

import CocoaLumberjackSwift
import Foundation

class DelayedURLProtocol: URLProtocol {
    
    static var delayTime: TimeInterval = 5 // Длительность задержки в секундах
    static var responseString = "Sample data" // Ответ, который будем возвращать
    
    override class func canInit(with request: URLRequest) -> Bool {
        return true
    }
    
    override class func canonicalRequest(for request: URLRequest) -> URLRequest {
        return request
    }
    
    override func startLoading() {
        // Имитируем задержку
        DispatchQueue.global().asyncAfter(deadline: .now() + DelayedURLProtocol.delayTime) {
            // Возвращаем успешный ответ
            let response = HTTPURLResponse(
                url: self.request.url!,
                statusCode: 200,
                httpVersion: nil,
                headerFields: nil
            )!
            
            self.client?.urlProtocol(self, didReceive: response, cacheStoragePolicy: .notAllowed)
            
            if let data = DelayedURLProtocol.responseString.data(using: .utf8) {
                self.client?.urlProtocol(self, didLoad: data)
            }
            
            self.client?.urlProtocolDidFinishLoading(self)
        }
    }
    
    override func stopLoading() {
        DDLogVerbose("Function stopLoading in DelayedURLProtocol called at: \(Date.now.toString())")
    }
}
