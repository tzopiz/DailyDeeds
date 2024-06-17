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
     
     This function allows sorting of any sequence where the elements conform to the `KeyPathComparable` protocol by a specified key path. The key path must point to a value that conforms to the `Comparable` protocol.
     
     - Parameter keyPath: A key path to a property of `Element` that conforms to `Comparable`.
     - Returns: A sorted array of the sequence elements, sorted by the values at the specified key path with ascending order by default
     - Complexity: O(n log n), where n is the length of the collection.
     
     Usage example:
     ```swift
     struct TodoItem2: KeyPathComparable {
         let id: String
         var text: String
         var importance: Int
         var isDone: Bool
         let creationDate: Date
     }
     
     var todoItems: [TodoItem2] = [
         TodoItem2(id: "3", text: "Task 3", importance: 10, isDone: false, creationDate: Date()),
         TodoItem2(id: "1", text: "Task 1", importance: 2, isDone: false, creationDate: Date()),
         TodoItem2(id: "2", text: "Task 2", importance: 4, isDone: false, creationDate: Date())
     ]
     
     let sortedItems = todoItems.sorted(by: \.id)
     let filterItems = todoItems.filter(by: \.isDone) { $0 == true }
     todoItems.sort(by: \.importance)
     print(sortedItems) // Will print items sorted by their id in ascending order
     print(filterItems) // Will print items filter by their isDone state
     ```
     */
    func sorted<T: Comparable>(by keyPath: KeyPath<Element, T>, ascending: Bool = true) -> [Element] {
        if ascending {
            return self.sorted(by: Element.compareBy(keyPath))
        } else {
            return self.sorted(by: Element.compareBy(keyPath)).reversed()
        }
    }
    mutating func sort<T: Comparable>(by keyPath: KeyPath<Element, T>, ascending: Bool = true) {
        guard let sorted = self.sorted(by: Element.compareBy(keyPath)) as? Self
        else { return }
        if ascending { self = sorted }
        else {
            guard let reversed = sorted.reversed() as? Self
            else { return }
            self = reversed
        }
    }
    func filter<T>(by keyPath: KeyPath<Element, T>, predicate: @escaping (T) -> Bool) -> [Element] {
        return self.filter { element in
            predicate(element[keyPath: keyPath])
        }
    }
}
