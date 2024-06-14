//
//  KeyPathComparable.swift
//  DailyDeeds
//
//  Created by Дмитрий Корчагин on 6/14/24.
//

import Foundation

protocol KeyPathComparable {
    associatedtype ComparableType: Comparable
    var keyPath: KeyPath<Self, ComparableType> { get }
    
    static func compareBy<T: Comparable>(_ keyPath: KeyPath<Self, T>) -> (Self, Self) -> Bool
}

extension KeyPathComparable {
    static func compareBy<T: Comparable>(_ keyPath: KeyPath<Self, T>) -> (Self, Self) -> Bool {
        return { (lhs, rhs) in
            lhs[keyPath: keyPath] < rhs[keyPath: keyPath]
        }
    }
}

// MARK: - KeyPathComparable
extension TodoItem: KeyPathComparable {
    var keyPath: KeyPath<TodoItem, String> {
        return \TodoItem.id
    }
}

extension Sequence where Element: KeyPathComparable {
    func sorted<T: Comparable>(by keyPath: KeyPath<Element, T>) -> [Element] {
        self.sorted(by: Element.compareBy(keyPath))
    }
}
