//
//  TestNetworkingService.swift
//  DailyDeeds
//
//  Created by Дмитрий Корчагин on 7/16/24.
//

import CocoaLumberjackSwift
@testable import DailyDeeds
import FileCache
import XCTest

final class TestNetworkingService: XCTestCase {
    var sut: DefaultNetworkingService!
    var session: URLSession!
    var mockURL: URL!
    
    private let expectedId = "123"
    private let expectedText = "blablabla"
    private let expectedImportance = "basic"
    private let expectedDeadline = Date(timeIntervalSince1970: 1627868400)
    private let expectedDone = false
    private let expectedColor = "#FFFF23"
    private let expectedCreatedAt = Date(timeIntervalSince1970: 1627864800)
    private let expectedChangedAt = Date(timeIntervalSince1970: 1627864800)
    private let expectedLastUpdatedBy = "device_1"
    
    override func setUp() {
        super.setUp()
        
        let configuration = URLSessionConfiguration.ephemeral
        configuration.protocolClasses = [MockURLProtocol.self]
        
        session = URLSession(configuration: configuration)
        sut = DefaultNetworkingService(session: session)
        mockURL = URL(string: "https://example.com")!
    }
    
    override func tearDown() {
        sut = nil
        session = nil
        mockURL = nil
        MockURLProtocol.requestHandler = nil
        MockURLProtocol.error = nil
        super.tearDown()
    }
    
    func testDataTaskCancellation() async throws {
        let expectation = XCTestExpectation(description: "Data task should be cancelled")
        MockURLProtocol.delayTime = 2.0
        MockURLProtocol.requestHandler = { request in
            let response = HTTPURLResponse(
                url: URL(string: "https://example.com")!,
                statusCode: 200,
                httpVersion: nil,
                headerFields: nil
            )
            let data = Data()
            return (response!, data)
        }
        
        let task = Task {
            var urlRequest = URLRequest(url: mockURL)
            urlRequest.httpMethod = "GET"
            do {
                DDLogInfo("Task start at: \(Date.now.toString())")
                let _ = try await session.dataTask(for: urlRequest)
                XCTFail("Expected task to be cancelled, but it completed successfully.")
            } catch {
                expectation.fulfill()
            }
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            task.cancel()
        }
        
        // Ожидаем выполнения теста
        await fulfillment(of: [expectation], timeout: 2.0)
    }
    
    func testFetchTodoListSuccess() async throws {
        let expectedData: [String: Any] = [
            "status": "ok",
            "list": [
                [
                    "id": expectedId,
                    "text": expectedText,
                    "importance": expectedImportance,
                    "deadline": expectedDeadline.timeIntervalSince1970,
                    "done": expectedDone,
                    "color": expectedColor,
                    "created_at": expectedCreatedAt.timeIntervalSince1970,
                    "changed_at": expectedChangedAt.timeIntervalSince1970,
                    "last_updated_by": expectedLastUpdatedBy
                ],
                [
                    "id": expectedId + expectedId,
                    "text": expectedText + expectedText,
                    "importance": expectedImportance,
                    "deadline": expectedDeadline.timeIntervalSince1970,
                    "done": expectedDone,
                    "color": expectedColor,
                    "created_at": expectedCreatedAt.timeIntervalSince1970,
                    "changed_at": expectedChangedAt.timeIntervalSince1970,
                    "last_updated_by": expectedLastUpdatedBy
                ]
            ],
            "revision": 1
        ]
        
        MockURLProtocol.requestHandler = { request in
            let response = HTTPURLResponse(url: request.url!, statusCode: 200, httpVersion: nil, headerFields: nil)!
            let data = try! JSONSerialization.data(withJSONObject: expectedData)
            return (response, data)
        }
        
        let response: TodoListResponse = try await sut.fetchTodoList()
        
        XCTAssertEqual(response.status, "ok")
        XCTAssertEqual(response.result.count, 2)
        XCTAssertEqual(response.result.first?.id, expectedId)
        XCTAssertEqual(response.result.first?.text, expectedText)
        XCTAssertEqual(response.result.last?.id, expectedId + expectedId)
        XCTAssertEqual(response.result.last?.text, expectedText + expectedText)
        XCTAssertEqual(response.revision, 1)
    }
    
    func testFetchTodoItemSuccess() async throws {
        let status = "ok"
        let revision = 1
        let expectedData: [String: Any] = [
            "status": status,
            "element": [
                "id": expectedId,
                "text": expectedText,
                "importance": expectedImportance,
                "deadline": expectedDeadline.timeIntervalSince1970,
                "done": expectedDone,
                "color": expectedColor,
                "created_at": expectedCreatedAt.timeIntervalSince1970,
                "changed_at": expectedChangedAt.timeIntervalSince1970,
                "last_updated_by": expectedLastUpdatedBy
            ],
            "revision": revision
        ]
        
        MockURLProtocol.requestHandler = { request in
            let response = HTTPURLResponse(url: request.url!, statusCode: 200, httpVersion: nil, headerFields: nil)!
            let data = try! JSONSerialization.data(withJSONObject: expectedData)
            return (response, data)
        }
        
        let response: TodoItemResponse = try await sut.fetchTodoItem(id: expectedId)
        
        XCTAssertEqual(response.status, status)
        XCTAssertEqual(response.result?.id, expectedId)
        XCTAssertEqual(response.result?.text, expectedText)
        XCTAssertEqual(response.result?.hexColor, expectedColor)
        XCTAssertEqual(response.revision, revision)
    }
}
