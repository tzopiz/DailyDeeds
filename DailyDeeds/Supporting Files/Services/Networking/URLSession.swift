//
//  URLSession.swift
//  DailyDeeds
//
//  Created by Дмитрий Корчагин on 7/9/24.
//

import Foundation
import CocoaLumberjackSwift

/**
 * - swiftlint install
 * - swiftlint use
 * - networking
 */

extension URLSession {
    func dataTask(for urlRequest: URLRequest) async throws -> (Data, URLResponse) {
        return try await withCheckedThrowingContinuation { continuation in
            let task = self.dataTask(with: urlRequest) { data, response, error in
                // FIXME: -
                if Task.isCancelled {
                    let cancellationError = CancellationError()
                    DDLogError("Request cancelled: \(cancellationError.localizedDescription)")
                    continuation.resume(throwing: cancellationError)
                    return
                }
                
                if let data = data, let response = response {
                    DDLogVerbose("Request completed successfully")
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
            
            task.resume()
        }
    }
}
