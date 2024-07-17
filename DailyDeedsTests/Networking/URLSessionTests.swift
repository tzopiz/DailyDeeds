//
//  URLSessionTests.swift
//  DailyDeeds
//
//  Created by Дмитрий Корчагин on 7/16/24.
//

import CocoaLumberjackSwift
@testable import DailyDeeds
import XCTest

class URLSessionTests: XCTestCase {
    var urlSession: URLSession!
    var mockURL: URL!

    override func setUp() {
        super.setUp()

        let config = URLSessionConfiguration.ephemeral
        config.protocolClasses = [DelayedURLProtocol.self]
        urlSession = URLSession(configuration: config)
        mockURL = URL(string: "https://example.com")!
    }

    override func tearDown() {
        urlSession = nil
        mockURL = nil
        super.tearDown()
    }

    func testDataTaskCancellation() async throws {
        let expectation = XCTestExpectation(description: "Data task should be cancelled")

        let task = Task {
            var urlRequest = URLRequest(url: mockURL)
            urlRequest.httpMethod = "GET"
            do {
                DDLogInfo("Task start at: \(Date.now.toString())")
                let _ = try await urlSession.dataTask(for: urlRequest)
                XCTFail("Expected task to be cancelled, but it completed successfully.")
            } catch {
                expectation.fulfill()
            }
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            task.cancel()
        }

        // Ожидаем выполнения теста
        await fulfillment(of: [expectation], timeout: 5.0)
    }
}
