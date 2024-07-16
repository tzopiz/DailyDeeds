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

        // Создаем задачу в новой Task
        let task = Task {
            // Создаем URLRequest
            var urlRequest = URLRequest(url: mockURL)
            urlRequest.httpMethod = "GET"
            do {
                DDLogInfo("Task start at: \(Date.now.toString())")
                let (data, response) = try await urlSession.dataTask(for: urlRequest)
                XCTFail("Expected task to be cancelled, but it completed successfully.")
            } catch {
//                XCTAssertTrue((error as NSError).code == NSURLErrorCancelled, "Expected task to be cancelled")
                expectation.fulfill()
            }
        }
        // FIXME: -
        // The task is correctly canceled, but continues to load in the background even after cancellation

        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            task.cancel()
        }

        // Ожидаем выполнения теста
        await fulfillment(of: [expectation], timeout: 5.0)
    }
}
