//
//  Collection.swift
//  DailyDeeds
//
//  Created by Дмитрий Корчагин on 6/17/24.
//

import Foundation
import FileCache

extension Collection {
    subscript(safe index: Index) -> Element? {
        return indices.contains(index) ? self[index] : nil
    }
}

extension Collection where Element: JSONParsable {
    var jsonArray: [JSONDictionary] {
        self.reduce(into: []) { partialResult, element in
            partialResult.append(element.json)
        }
    }
}
