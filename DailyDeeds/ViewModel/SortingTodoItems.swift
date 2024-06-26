//
//  TodoItemCriteria.swift
//  DailyDeeds
//
//  Created by Дмитрий Корчагин on 6/26/24.
//

import Foundation

enum TaskCriteria {
    case filter(FilterType)
    case sort(SortType)
    
    enum FilterType {
        case notCompletedOnly
        case all
    }

    enum SortType: Hashable {
        case byCreationDate(Order = .ascending)
        case byDeadline(Order = .ascending)
        case byImportance(Order = .ascending)
        case byLastModifiedDate(Order = .ascending)
        case byCompletionStatus(Order = .ascending)

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
        }
        
        init(_ option: SortType, order: Order = .ascending) {
            switch option {
            case .byCreationDate:
                self = .byCreationDate(order)
            case .byDeadline:
                self = .byDeadline(order)
            case .byLastModifiedDate:
                self = .byLastModifiedDate(order)
            case .byImportance:
                self = .byImportance(order)
            case .byCompletionStatus:
                self = .byCompletionStatus(order)
            }
        }
        
        var order: Order {
            switch self {
            case .byCreationDate(let order),
                    .byDeadline(let order),
                    .byLastModifiedDate(let order),
                    .byImportance(let order),
                    .byCompletionStatus(let order):
                return order
            }
        }

        var shortDescription: String {
            switch self {
            case .byCreationDate:
                return "По дате создания"
            case .byDeadline:
                return "По сроку выполнения"
            case .byLastModifiedDate:
                return "По дате изменения"
            case .byImportance:
                return "По важности"
            case .byCompletionStatus:
                return "По статусу выполнения"
            }
        }

        var description: String {
            switch self {
            case .byCreationDate(let order):
                return order.isAscending ? "Сначала старые" : "Сначала новые"
            case .byDeadline(let order):
                return order.isAscending ? "Скоро дедлайн" : "Дедлайн не скоро"
            case .byLastModifiedDate(let order):
                return order.isAscending ? "Недавно измененные" : "Давно измененные"
            case .byImportance(let order):
                return order.isAscending ? "Сначала неважные" : "Сначала важные"
            case .byCompletionStatus(let order):
                return order.isAscending ? "Сначала невыполненные" : "Сначала выполненные"
            }
        }

        var fullDescription: String {
            switch self {
            case .byCreationDate,
                    .byDeadline,
                    .byImportance,
                    .byLastModifiedDate,
                    .byCompletionStatus:
                return "\(shortDescription) (\(description))"
            }
        }
    }
}
