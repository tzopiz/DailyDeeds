//
//  KeyPathComparable.swift
//  DailyDeeds
//
//  Created by Дмитрий Корчагин on 6/14/24.
//

import Foundation

protocol KeyPathComparable {
    static func compareBy<T: Comparable>(_ keyPath: KeyPath<Self, T>) -> (Self, Self) -> Bool
}

extension KeyPathComparable {
    static func compareBy<T: Comparable>(_ keyPath: KeyPath<Self, T>) -> (Self, Self) -> Bool {
        return { (lhs, rhs) in
            lhs[keyPath: keyPath] < rhs[keyPath: keyPath]
        }
    }
}

extension Sequence where Element: KeyPathComparable {
    /**
     Sorts the elements of a sequence based on the values at a specified key path with ascending order by default.
     
     - Parameter keyPath: A key path to a property of `Element` that conforms to `Comparable`.
     - Returns: A sorted array of the sequence elements, sorted by the values at the specified key path with ascending order by default
     - Complexity: O(n log n), where n is the length of the collection.
     */
    func sorted<T: Comparable>(by keyPath: KeyPath<Element, T>, ascending: Bool = true) -> [Element] {
        if ascending {
            return self.sorted(by: Element.compareBy(keyPath))
        } else {
            return self.sorted(by: Element.compareBy(keyPath)).reversed()
        }
    }
    
    mutating func sort<T: Comparable>(by keyPath: KeyPath<Element, T>, ascending: Bool = true) {
        guard let sorted = self.sorted(by: keyPath, ascending: ascending) as? Self
        else { return }
        self = sorted
    }
    
    func filter<T>(by keyPath: KeyPath<Element, T>, predicate: @escaping (T) -> Bool) -> [Element] {
        return self.filter { element in
            predicate(element[keyPath: keyPath])
        }
    }
}
