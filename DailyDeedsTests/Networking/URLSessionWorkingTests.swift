//
//  URLSessionWorkingTests.swift
//  DailyDeeds
//
//  Created by Дмитрий Корчагин on 7/9/24.
//

import XCTest
@testable import DailyDeeds

final class URLSessionWorkingTests: XCTestCase {

    func testGETRequest() async throws {
        let url = URL(string: "https://jsonplaceholder.typicode.com/posts/1")!
        let request = URLRequest(url: url)

        do {
            let (data, response) = try await URLSession.shared.dataTask(for: request)

            XCTAssertNotNil(data)
            XCTAssertNotNil(response)

            if let httpResponse = response as? HTTPURLResponse {
                XCTAssertEqual(httpResponse.statusCode, 200)
            } else {
                XCTFail("Response is not an HTTPURLResponse")
            }

        } catch {
            XCTFail("Failed with error: \(error)")
        }
    }

    func testPOSTRequest() async throws {
        let url = URL(string: "https://jsonplaceholder.typicode.com/posts")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        let requestBody: [String: Any] = [
            "title": "foo",
            "body": "bar",
            "userId": 1
        ]
        request.httpBody = try? JSONSerialization.data(withJSONObject: requestBody)

        do {
            let (data, response) = try await URLSession.shared.dataTask(for: request)

            XCTAssertNotNil(data)
            XCTAssertNotNil(response)

            if let httpResponse = response as? HTTPURLResponse {
                XCTAssertEqual(httpResponse.statusCode, 201)
            } else {
                XCTFail("Response is not an HTTPURLResponse")
            }

        } catch {
            XCTFail("Failed with error: \(error)")
        }
    }

    func testPUTRequest() async throws {
        let url = URL(string: "https://jsonplaceholder.typicode.com/posts/1")!
        var request = URLRequest(url: url)
        request.httpMethod = "PUT"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        let requestBody: [String: Any] = [
            "id": 1,
            "title": "foo",
            "body": "bar",
            "userId": 1
        ]
        request.httpBody = try? JSONSerialization.data(withJSONObject: requestBody)

        do {
            let (data, response) = try await URLSession.shared.dataTask(for: request)

            XCTAssertNotNil(data)
            XCTAssertNotNil(response)

            if let httpResponse = response as? HTTPURLResponse {
                XCTAssertEqual(httpResponse.statusCode, 200)
            } else {
                XCTFail("Response is not an HTTPURLResponse")
            }

        } catch {
            XCTFail("Failed with error: \(error)")
        }
    }

    func testDELETERequest() async throws {
        let url = URL(string: "https://jsonplaceholder.typicode.com/posts/1")!
        var request = URLRequest(url: url)
        request.httpMethod = "DELETE"

        do {
            let (data, response) = try await URLSession.shared.dataTask(for: request)

            XCTAssertNotNil(data)
            XCTAssertNotNil(response)

            if let httpResponse = response as? HTTPURLResponse {
                XCTAssertEqual(httpResponse.statusCode, 200)
            } else {
                XCTFail("Response is not an HTTPURLResponse")
            }

        } catch {
            XCTFail("Failed with error: \(error)")
        }
    }

    func testErrorHandling() async throws {
        let url = URL(string: "123123")! // несуществующий URL
        let request = URLRequest(url: url)

        do {
            _ = try await URLSession.shared.dataTask(for: request)

            // Если мы ожидаем ошибку, то тест не должен дойти до этой строки
            XCTFail("Expected error but request succeeded")

        } catch {
            // Проверяем, что ошибка соответствует ожиданиям
            XCTAssertTrue(error is URLError, "Expected URLError, got \(type(of: error))")
        }
    }

}
