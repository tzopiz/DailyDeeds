//
//  URLSession.swift
//  DailyDeeds
//
//  Created by Дмитрий Корчагин on 7/9/24.
//

import CocoaLumberjackSwift
import Foundation

extension URLSession {
    fileprivate actor CancelState {
        var task: URLSessionTask?
        var isCancelled: Bool = false
        
        func activate(task: URLSessionTask) {
            if isCancelled {
                task.cancel()
            } else {
                self.task = task
                task.resume()
            }
        }
        
        func cancel() {
            isCancelled = true
            task?.cancel()
        }
    }
    
    func dataTask(for urlRequest: URLRequest) async throws -> (Data, URLResponse) {
        let cancelState = CancelState()
        return try await withTaskCancellationHandler {
            return try await withCheckedThrowingContinuation { continuation in
                let dataTask = self.dataTask(with: urlRequest) { data, response, error in
                    if let data = data, let response = response {
                        DDLogVerbose("Request completed successfully")
                        continuation.resume(returning: (data, response))
                    } else if let error = error as? NSError {
                        let errorMessage = "Request failed with error: \(error)"
                        let infoMessage = "\nDomain: \(error.domain), Code: \(error.code)"
                        let message = DDLogMessageFormat(stringLiteral: errorMessage + infoMessage)
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
                Task {
                    await cancelState.activate(task: dataTask)
                }
            }
        } onCancel: {
            Task {
                await cancelState.cancel()
                DDLogVerbose("Request was cancelled")
            }
        }
    }
}
