//
//  URLSession.swift
//  DailyDeeds
//
//  Created by Дмитрий Корчагин on 7/9/24.
//

import CocoaLumberjackSwift
import Foundation

fileprivate struct Lock<State>: @unchecked Sendable {
    let stateLock: ManagedBuffer<State, NSLock>
    init(initialState: State) {
        stateLock = .create(minimumCapacity: 1) { buffer in
            buffer.withUnsafeMutablePointerToElements { lock in
                lock.initialize(to: .init())
            }
            return initialState
        }
    }

    func withLock<R>(_ body: @Sendable (inout State) throws -> R) rethrows -> R where R : Sendable {
        return try stateLock.withUnsafeMutablePointers { header, lock in
            lock.pointee.lock()
            defer {
                lock.pointee.unlock()
            }
            return try body(&header.pointee)
        }
    }
}

fileprivate extension URLSession {
    final class CancelState: Sendable {
        struct State {
            var isCancelled: Bool
            var task: URLSessionTask?
        }
        let lock: Lock<State>

        init() {
            lock = Lock(initialState: State(isCancelled: false, task: nil))
        }

        func cancel() {
            let task = lock.withLock { state in
                state.isCancelled = true
                let result = state.task
                state.task = nil
                return result
            }
            task?.cancel()
        }

        func activate(task: URLSessionTask) {
            let taskUsed = lock.withLock { state in
                if state.task != nil {
                    fatalError("Cannot activate twice")
                }
                if state.isCancelled {
                    return false
                } else {
                    state.isCancelled = false
                    state.task = task
                    return true
                }
            }

            if !taskUsed {
                task.cancel()
            }
        }
    }
}

extension URLSession {
    func dataTask(for urlRequest: URLRequest) async throws -> (Data, URLResponse) {
        let cancelState = CancelState()
        return try await withTaskCancellationHandler {
            return try await withCheckedThrowingContinuation { continuation in
                let dataTask = self.dataTask(with: urlRequest) { data, response, error in
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
                dataTask.resume()
                cancelState.activate(task: dataTask)
            }
        } onCancel: {
            DDLogVerbose("Request was cancelled, at: \(Date.now.toString())")
            cancelState.cancel()
        }
    }
}
