//
//  TodoItemModel + Networking.swift
//  DailyDeeds
//
//  Created by Дмитрий Корчагин on 7/19/24.
//

import CocoaLumberjackSwift
import Foundation

extension TodoItemModel {
    var minDelay: TimeInterval { 2 }
    var maxDelay: TimeInterval { 120 }
    var factor: Double { 1.5 }
    var jitter: Double { 0.05 }
    var checkInterval: TimeInterval { 1 }
    
    @MainActor
    func startMonitoringNetworkActivity() async {
        // FIXME: - spinlock -> subscribers pattern
        monitorTask = Task {
            while !Task.isCancelled {
                let activeRequestsCount = await networkingService.getActiveRequestsCount()
                let shouldLoad = activeRequestsCount > 0
                
                if isLoading != shouldLoad {
                    isLoading = shouldLoad
                }
                
                do {
                    try await Task.sleep(nanoseconds: UInt64(checkInterval * 1_000_000_000))
                } catch {
                    DDLogError("Failed to monitor network activity: \(error)")
                }
            }
        }
        DDLogInfo("Start monitoring network activity")
    }
    
    func stopMonitoringNetworkActivity() {
        monitorTask?.cancel()
        monitorTask = nil
        DDLogInfo("Stop monitoring network activity")
    }
    
    // FIXME: - Collisions between local and cloud data
    // There's no problem right now, but will be in future
    @MainActor
    func fetchTodoList(tryRetry: Bool = true) {
        handleNetworkTask(#function, tryRetry: tryRetry) {
            try await self.networkingService.fetchTodoList()
        } onSuccess: { response in
            self.updateList(response.result)
        }
    }
    
    @MainActor
    func fetchTodoItem(with id: String, tryRetry: Bool = true) {
        handleNetworkTask(#function, tryRetry: tryRetry) {
            try await self.networkingService.fetchTodoItem(id: id)
        } onSuccess: { response in
            self.updateItem(with: id, item: response.result)
        }
    }
    
    @MainActor
    func updateTodoItem(with id: String, item: TodoItem, tryRetry: Bool = true) {
        self.updateItem(with: id, item: item)
        handleNetworkTask(#function, tryRetry: tryRetry) {
            try await self.networkingService.updateTodoItem(id: id, data: item, revision: self.revision)
        } onSuccess: { response in
            return self.updateItem(with: id, item: response.result)
        }
    }
    
    @MainActor
    func updateTodoList(tryRetry: Bool = true) {
        handleNetworkTask(#function, tryRetry: tryRetry) {
            try await self.networkingService.updateTodoList(patchData: self.items, revision: self.revision)
        } onSuccess: { response in
            self.updateList(response.result)
        }
    }
    
    @MainActor
    func createTodoItem(with id: String, item: TodoItem, tryRetry: Bool = true) {
        self.append(item)
        handleNetworkTask(#function, tryRetry: tryRetry) {
            try await self.networkingService.createTodoItem(data: item, revision: self.revision)
        } onSuccess: { response in
            self.append(response.result)
        }
    }
    
    @MainActor
    func deleteTodoItem(with id: String, tryRetry: Bool = true) {
        self.remove(with: id)
        handleNetworkTask(#function, tryRetry: tryRetry) {
            try await self.networkingService.deleteTodoItem(id: id, revision: self.revision)
        } onSuccess: { response in
            if let item = response.result {
                self.remove(with: id)
                DDLogInfo("TodoItem has been deleted:\n\(item.description)")
            } else {
                DDLogError("No TodoItem with id \(id) on server")
            }
        }
    }
    
    @MainActor
    private func handleNetworkTask<T: ITodoResponse & Sendable>(
        _ title: String = "", tryRetry: Bool,
        task: @escaping () async throws -> T,
        onSuccess: @escaping (T) async -> Void
    ) {
        Task {
            // можно и while true он все равно закончить работу, но на всякий случай пусть будет так
            for retryCount in 0..<20 {
                guard retryCount == 0 || tryRetry else { return }
                do {
                    let response = try await task()
                    await onSuccess(response)
                    self.updateRevision(to: response.revision)
                    self.makeDirty(false)
                    DDLogVerbose("TodoItemModel.\(title) finished Successfully")
                    return
                } catch let error as NetworkingError {
                    DDLogError("TodoItemModel.\(title) failed with \(error.description)")

                    switch error {
                    case .invalidResponse, .parsingError, .invalidBodyType,
                            .noInternetConnection, .httpError, .unknown:
                        self.makeDirty(true)
                        self.save(to: self.defaultFileName, format: .json)
                        return
                    case .serverError, .requestTimeout:
                        let delay = exponentialBackoff(retryCount: retryCount)
                        DDLogError("Retrying TodoItemModel.\(title) after \(delay) seconds due to \(error.description)")
                        
                        if delay >= maxDelay {
                            DDLogError("Max retry limit reached for TodoItemModel.\(title)")
                            DDLogInfo("Trying fetch latest data from server.")
                            self.fetchTodoList(tryRetry: false)
                            return
                        }
                        
                        try await Task.sleep(nanoseconds: UInt64(delay * 1_000_000_000))
                    }
                } catch {
                    DDLogError("TodoItemModel.\(title) failed with unhandled error: \(error)")
                }
            }
        }
    }
    
    private func exponentialBackoff(retryCount: Int) -> TimeInterval {
        let baseDelay = minDelay * pow(factor, Double(retryCount))
        let jitterValue = baseDelay * Double.random(in: -jitter...jitter)
        return min(maxDelay, baseDelay + jitterValue)
    }
}
