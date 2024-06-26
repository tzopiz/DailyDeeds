//
//  TodoItemViewModel.swift
//  DailyDeeds
//
//  Created by Дмитрий Корчагин on 6/23/24.
//

import SwiftUI

class TodoItemViewModel: ObservableObject {
    @Published
    private(set) var model = FileCache()
    
    @Published 
    var sortType: SortType = .none

    var items: Array<TodoItem> {
        switch sortType {
        case .byCreationDate(let order):
            return model.todoItems.sorted(by: \.creationDate, ascending: order.isAscending)
        case .byDeadline(let order):
            return model.todoItems.sorted(by: \.deadline, ascending: order.isAscending)
        case .byDateModified(let order):
            return model.todoItems.sorted(by: \.modificationDate, ascending: order.isAscending)
        case .byImportance(let order):
            return model.todoItems.sorted(by: \.importance, ascending: order.isAscending)
        case .byIsDone(let order):
            return model.todoItems.sorted(by: \.isDone, ascending: order.isAscending)
        case .isDoneOnly(let order):
            return model.todoItems.filter(by: \.isDone) { order == .ascending ? $0 : !$0 }
        case .none:
            return model.todoItems
        }
    }
    
    var completeTodoItemsCount: Int {
        items.filter(by: \.isDone, predicate: { $0 }).count
    }

    
    init(model: FileCache = FileCache(), items: Array<TodoItem> = []) {
        self.model = model
        self.addTodoItems(items)
    }
    
    // MARK: - Delete
    func removeAll() {
        for item in items {
            model.remove(with: item.id)
        }
    }
    
    func remove(with id: String) {
        model.remove(with: id)
    }
    
    func remove(at offsets: IndexSet) {
        model.remove(at: offsets)
    }
    
    // MARK: - Create
    func append(_ item: TodoItem) {
        model.append(item)
    }
    
    func addTodoItems(_ items: Array<TodoItem>) {
        items.forEach { model.append($0) }
    }
    
    // MARK: - Update
    func move(fromOffsets indices: IndexSet, toOffset newOffset: Int) {
        model.move(fromOffsets: indices, toOffset: newOffset)
    }
    
    // MARK: - Save
    func save(to fileName: String, format type: FileCache.FileFormat = .json) {
        if let error = model.saveToFile(named: fileName, format: type) {
            print(error.localizedDescription)
        }
    }
    
    // MARK: - Read
    func loadItems(from fileName: String, format type: FileCache.FileFormat = .json) {
        let result = model.loadFromFile(named: fileName, format: type)
        switch result {
        case .success(let items):
            removeAll()
            addTodoItems(items)
        case .failure(let error):
            print(error.localizedDescription)
        }
    }
    
    // MARK: - Sorting
    func setSortType(_ sortType: SortType) {
        self.sortType = sortType
    }
}

extension TodoItemViewModel {
    static func createTodoItems(_ n: Int) -> [TodoItem] {
        var items = [TodoItem]()

        let texts = [
            "Buy groceries for the week, including fresh vegetables, fruits, dairy products, and some snacks for the kids.",
            "Call mom to check in and see how she's doing. Don't forget to ask about her recent doctor's appointment.",
            "Finish homework for the mathematics course, including all exercises from chapter 5 and review the notes for the upcoming test.",
            "Clean the house thoroughly, including dusting all the furniture, vacuuming the carpets, and mopping the floors.",
            "Prepare presentation for the next team meeting, focusing on the project milestones achieved and the goals for the next quarter.",
            "Go for a walk in the park to get some fresh air and a bit of exercise. Aim for at least 30 minutes of brisk walking.",
            "Read a book on personal development. This month's pick is 'Atomic Habits' by James Clear. Try to read at least two chapters.",
            "Write a blog post about the latest trends in technology and how they are impacting our daily lives. Aim for at least 1000 words.",
            "Workout session at the gym, focusing on strength training exercises. Don't forget to do a proper warm-up and cool-down.",
            "Plan the trip to the mountains for the upcoming holiday. Make a list of all the necessary gear and supplies to pack."
        ]

        let importanceLevels: [Importance] = [.low, .medium, .high]

        for i in 0..<n {
            let text = texts[i % texts.count]
            let importance = importanceLevels[Int.random(in: 0..<importanceLevels.count)]
            let isDone = Bool.random()
            let creationDate: Date = .now
            let deadline = Bool.random() ? Date().addingTimeInterval(Double(i) * 86400 + 86400) : nil // случайный дедлайн

            let item = TodoItem(
                text: text,
                isDone: isDone,
                importance: importance,
                creationDate: creationDate,
                deadline: deadline
            )

            items.append(item)
        }

        return items
    }
}