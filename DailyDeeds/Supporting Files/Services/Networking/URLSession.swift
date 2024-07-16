//
//  URLSession.swift
//  DailyDeeds
//
//  Created by Дмитрий Корчагин on 7/9/24.
//

import CocoaLumberjackSwift
import Foundation

extension URLSession {
    func dataTask(for urlRequest: URLRequest) async throws -> (Data, URLResponse) {
        var dataTask: URLSessionDataTask?
        
        return try await withTaskCancellationHandler {
            return try await withCheckedThrowingContinuation { continuation in
                dataTask = self.dataTask(with: urlRequest) { data, response, error in
                    if let data = data, let response = response {
                        DDLogVerbose("Request completed successfully at: \(Date.now.toString())")
                        continuation.resume(returning: (data, response))
                    } else if let error = error {
                        var errorMessage = "Request failed with error: \(error.localizedDescription)"
                        if case let underlyingError = error as NSError {
                            errorMessage += "\nDomain: \(underlyingError.domain), Code: \(underlyingError.code)"
                        }
                        let message = DDLogMessageFormat(stringLiteral: errorMessage)
                        DDLogError(message)
                        continuation.resume(throwing: error)
                    } else {
                        let unknownError = NSError(
                            domain: "URLSessionErrorDomain",
                            code: -1,
                            userInfo: [NSLocalizedDescriptionKey: "Unknown error"]
                        )
                        DDLogError("Request failed with unknown error")
                        continuation.resume(throwing: unknownError)
                    }
                }
                dataTask?.resume()
            }
        } onCancel: { [weak dataTask] in
            DDLogVerbose("Request was cancelled, at: \(Date.now.toString())")
            dataTask?.cancel()
        }
    }
}
