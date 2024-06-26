//
//  SortingTodoItems.swift
//  DailyDeeds
//
//  Created by Дмитрий Корчагин on 6/26/24.
//

import Foundation

enum SortType: Hashable {
    case byCreationDate(Order = .ascending)
    case byDeadline(Order = .ascending)
    case byImportance(Order = .ascending)
    case byDateModified(Order = .ascending)
    case byIsDone(Order = .ascending)
    case isDoneOnly(Order = .ascending)
    case none
    
    enum Order {
        case ascending
        case descending
        
        var isAscending: Bool {
            switch self {
            case .ascending:
                return true
            case .descending:
                return false
            }
        }
        
        var description: String {
            switch self {
            case .ascending:
                return "Возрастание"
            case .descending:
                return "Убывание"
            }
        }
    }
    
    init(_ option: SortType, order: Order = .ascending) {
        switch option {
        case .byCreationDate:
            self = .byCreationDate(order)
        case .byDeadline:
            self = .byDeadline(order)
        case .byDateModified:
            self = .byDateModified(order)
        case .byImportance:
            self = .byImportance(order)
        case .byIsDone:
            self = .byIsDone(order)
        case .isDoneOnly:
            self = .isDoneOnly(order)
        case .none:
            self = .none
        }
    }
    
    var shortDescription: String {
        switch self {
        case .byCreationDate:
            return "По дате создания"
        case .byDeadline:
            return "По сроку выполнения"
        case .byDateModified:
            return "По дате изменения"
        case .byImportance:
            return "По важности"
        case .byIsDone:
            return "По статусу выполнения"
        case .isDoneOnly:
            return "По стасу выполнения"
        case .none:
            return "Все дела"
        }
    }
    
    var description: String {
        switch self {
        case .byCreationDate(let order):
            return order == .ascending ? "Сначала новые" : "Сначала старые"
        case .byDeadline(let order):
            return order == .ascending ? "Скоро дедлайн" : "Дедлайн не скоро"
        case .byDateModified(let order):
            return order == .ascending ? "Недавно измененные" : "Давно измененные"
        case .byImportance(let order):
            return order == .ascending ? "Сначала неважные" : "Сначала важные"
        case .byIsDone(let order):
            return order == .ascending ? "Сначала невыполненные" : "Сначала выполненные"
        case .isDoneOnly(let order):
            return order == .ascending ? "Выполненные" : "Невыполненные"
        case .none:
            return "Без сортировки"
        }
    }
    var fullDescription: String {
        switch self {
        case .byCreationDate,
                .byDeadline,
                .byImportance,
                .byDateModified,
                .byIsDone,
                .isDoneOnly:
            return "\(shortDescription) (\(description))"
        case .none:
            return shortDescription
        }
    }
    
    var order: Order {
        switch self {
        case .byCreationDate(let order),
                .byDeadline(let order),
                .byDateModified(let order),
                .byImportance(let order),
                .byIsDone(let order),
                .isDoneOnly(let order):
            return order
        case .none:
            return .ascending
        }
    }
}
