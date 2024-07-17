//
//  Category + JSONParsable.swift
//  DailyDeeds
//
//  Created by Дмитрий Корчагин on 7/18/24.
//

import FileCache
import Foundation

// MARK: - JSONParsable
extension Category {
    var json: JSONDictionary {
        Category.buildJSONDictionary {
            (CodingKeys.id, id)
            (CodingKeys.name, name)
            (CodingKeys.color, color)
        }
    }

    static func parse(json dict: JSONType) -> Category? {
        guard let id = dict[CodingKeys.id] as? String,
              let name = dict[CodingKeys.name] as? String
        else { return Category.defaultCategory }
        return Category(id, name: name, color: dict[CodingKeys.color] as? String)
    }
}
