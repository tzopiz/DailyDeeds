//
//  TodoItemModel + Networking.swift
//  DailyDeeds
//
//  Created by Дмитрий Корчагин on 7/19/24.
//

import CocoaLumberjackSwift
import Foundation

extension TodoItemModel {
    private var defaultFileName: String { "todoItemsList.json" }
    private var minDelay: TimeInterval { 2 }
    private var maxDelay: TimeInterval { 120 }
    private var factor: Double { 1.5 }
    private var jitter: Double { 0.05 }
    private var checkInterval: TimeInterval { 1 }
    
    // FIXME: - spinlock -> subscribers pattern
    @MainActor
    func startMonitoringNetworkActivity() async {
        monitorTask = Task {
            while !Task.isCancelled {
                let activeRequestsCount = await networkingService.getActiveRequestsCount()
                let shouldLoad = activeRequestsCount > 0
                
                if isLoading != shouldLoad {
                    updateLoding(shouldLoad)
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
            let allItems = self.mergeUniqueItems(
                local: self.items,
                cloud: response.result,
                saveLocalChanges: false
            )
            self.updateList(allItems)
        }
    }
    
    @MainActor
    func fetchTodoItem(with id: String, tryRetry: Bool = true) {
        handleNetworkTask(#function, tryRetry: tryRetry) {
            try await self.networkingService.fetchTodoItem(id: id)
        } onSuccess: { response in
            self.update(item: response.result)
        }
    }
    
    @MainActor
    func updateTodoItem(with id: String, item: TodoItem, tryRetry: Bool = true) {
        self.update(item: item)
        handleNetworkTask(#function, tryRetry: tryRetry) {
            try await self.networkingService.updateTodoItem(id: id, item: item, revision: self.revision)
        } onSuccess: { response in
            self.update(item: response.result)
        }
    }
    
    @MainActor
    func updateTodoList(tryRetry: Bool = true) {
        handleNetworkTask(#function, tryRetry: tryRetry) {
            try await self.networkingService.updateTodoList(self.items, revision: self.revision)
        } onSuccess: { response in
            self.updateList(response.result)
        }
    }
    
    @MainActor
    func createTodoItem(with id: String, item: TodoItem, tryRetry: Bool = true) {
        self.append(item)
        handleNetworkTask(#function, tryRetry: tryRetry) {
            try await self.networkingService.createTodoItem(item: item, revision: self.revision)
        } onSuccess: { response in
            self.update(item: item)
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
                DDLogError("No TodoItem with id \(id) in TodoItemModel")
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
            outerLoop: for retryCount in 0..<20 {
                // TODO: refreshing after offline mode
                guard retryCount == 0 || tryRetry else { break }
                do {
                    let response = try await task()
                    await onSuccess(response)
                    self.updateRevision(to: response.revision)
                    self.makeDirty(false)
                    DDLogVerbose("TodoItemModel.\(title) finished Successfully")
                    break
                } catch let error as NetworkingError {
                    DDLogError("TodoItemModel.\(title) failed with \(error.description)")
                    self.makeDirty(true)
                    switch error {
                    case .invalidResponse, .parsingError, .noInternetConnection, .httpError, .unknown:
                        DDLogError("Breaking outer loop due to non-recoverable error")
                        break outerLoop
                    case .serverError, .requestTimeout:
                        let delay = exponentialBackoff(retryCount: retryCount)
                        DDLogError("Retrying TodoItemModel.\(title) after \(delay) seconds due to \(error.description)")
                        
                        if delay >= maxDelay {
                            DDLogError("Max retry limit reached for TodoItemModel.\(title)")
                            break outerLoop
                        }
                        
                        try await Task.sleep(nanoseconds: UInt64(delay * 1_000_000_000))
                    }
                } catch {
                    DDLogError("TodoItemModel.\(title) failed with unhandled error: \(error)")
                    break outerLoop
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
