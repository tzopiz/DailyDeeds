//
//  KeyPathComparable.swift
//  DailyDeeds
//
//  Created by Дмитрий Корчагин on 6/14/24.
//

import Foundation

protocol KeyPathComparable {
    static func compareBy<T: Comparable>(
        _ keyPath: KeyPath<Self,T>,
        ascending: Bool
    ) -> (Self, Self) -> Bool
    
    static func compareBy<T: Comparable>(
        _ keyPath: KeyPath<Self, T?>,
        ascending: Bool
    ) -> (Self, Self) -> Bool
}

extension KeyPathComparable {
    static func compareBy<T: Comparable>(
        _ keyPath: KeyPath<Self, T>,
        ascending: Bool = true
    ) -> (Self, Self) -> Bool {
        return { (lhs, rhs) in
            if ascending {
                return lhs[keyPath: keyPath] < rhs[keyPath: keyPath]
            } else {
                return lhs[keyPath: keyPath] > rhs[keyPath: keyPath]
            }
        }
    }
    
    static func compareBy<T: Comparable>(
        _ keyPath: KeyPath<Self, T?>,
        ascending: Bool = true
    ) -> (Self, Self) -> Bool {
        return { (lhs, rhs) in
            guard let lhsValue = lhs[keyPath: keyPath], let rhsValue = rhs[keyPath: keyPath] 
            else {
                return lhs[keyPath: keyPath] != nil
            }
            if ascending {
                return lhsValue < rhsValue
            } else {
                return lhsValue > rhsValue
            }
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
        return self.sorted(
            by: Element.compareBy(keyPath, ascending: ascending)
        )
    }
    
    func sorted<T: Comparable>(by keyPath: KeyPath<Element, T?>, ascending: Bool = true) -> [Element] {
        return self.sorted(
            by: Element.compareBy(keyPath, ascending: ascending)
        )
    }
    
    func filter<T>(by keyPath: KeyPath<Element, T>, predicate: @escaping (T) -> Bool) -> [Element] {
        return self.filter { element in
            predicate(element[keyPath: keyPath])
        }
    }
}
