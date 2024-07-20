//
//  MutableTodoItem.swift
//  DailyDeeds
//
//  Created by Дмитрий Корчагин on 6/26/24.
//

import Combine
import Foundation

final class MutableTodoItem: Identifiable, ObservableObject {

    @Published
    private(set) var id: String
    @Published
    var text: String
    @Published
    var isDone: Bool
    @Published
    var importance: Importance
    @Published
    var hexColor: String
    @Published
    private(set) var creationDate: Date
    @Published
    var deadline: Date
    @Published
    var isDeadlineEnabled: Bool
    @Published
    var modificationDate: Date
    @Published
    var category: Category

    private var cancellables = Set<AnyCancellable>()

    init(from item: TodoItem) {
        self.id = item.id
        self.text = item.text
        self.isDone = item.isDone
        self.importance = item.importance
        self.hexColor = item.hexColor
        self.creationDate = item.creationDate
        self.deadline = item.deadline ?? .now.tomorrow
        self.isDeadlineEnabled = item.deadline != nil
        self.modificationDate = item.modificationDate
        self.category = item.category
        setupBindings()
    }

    var immutable: TodoItem {
        TodoItem(
            id: self.id,
            text: self.text,
            isDone: self.isDone,
            hexColor: self.hexColor,
            creationDate: self.creationDate,
            category: self.category,
            importance: self.importance,
            modificationDate: self.modificationDate,
            deadline: isDeadlineEnabled ? self.deadline : nil
        )
    }

    private func setupBindings() {
        let textPublisher = $text.map { _ in }
        let isDonePublisher = $isDone.map { _ in }
        let importancePublisher = $importance.map { _ in }
        let hexColorPublisher = $hexColor.map { _ in }
        let deadlinePublisher = $deadline.map { _ in }
        let isDeadlineEnabledPublisher = $isDeadlineEnabled.map { _ in }
        let categoryPublisher = $category.map { _ in }

        Publishers.Merge7(
            textPublisher,
            isDonePublisher,
            importancePublisher,
            hexColorPublisher,
            deadlinePublisher,
            isDeadlineEnabledPublisher,
            categoryPublisher
        )
        .sink { [weak self] _ in
            self?.modificationDate = Date()
        }
        .store(in: &cancellables)
        /**
         - Все паблишеры объединяются в один с помощью Publishers.Merge7, который выпускает событие каждый раз, когда любое из объединенных свойств изменяется.
         - Когда объединенный паблишер выпускает событие (при изменении любого свойства),
         срабатывает блок sink, который обновляет modificationDate текущей датой и временем.
         - store(in: &cancellables) используется для хранения подписки, чтобы она не была освобождена и продолжала действовать.
         */
    }
}
