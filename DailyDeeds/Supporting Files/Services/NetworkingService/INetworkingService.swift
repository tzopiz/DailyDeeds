//
//  INetworkingService.swift
//  DailyDeeds
//
//  Created by Дмитрий Корчагин on 7/16/24.
//

import FileCache
import Foundation

protocol INetworkingService {
    func fetchTodoList() async throws -> TodoListResponse
    func updateTodoList(patchData: [JSONDictionary], revision: Int) async throws -> TodoListResponse
    func fetchTodoItem(id: String) async throws -> TodoItemResponse
    func createTodoItem(data: JSONDictionary, revision: Int) async throws -> TodoItemResponse
    func updateTodoItem(id: String, data: JSONDictionary, revision: Int) async throws -> TodoItemResponse
    func deleteTodoItem(id: String, revision: Int) async throws -> TodoItemResponse
}
