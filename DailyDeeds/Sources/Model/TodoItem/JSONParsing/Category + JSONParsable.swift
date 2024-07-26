//
//  Category + JSONParsable.swift
//  DailyDeeds
//
//  Created by Дмитрий Корчагин on 7/18/24.
//

import CocoaLumberjackSwift
import FileCache
import Foundation

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
              let name = dict[CodingKeys.name] as? String else {
            DDLogError("Category.\(#function): Failed parse Category object")
            return Category.default
        }
        return Category(id: id, name: name, color: dict[CodingKeys.color] as? String)
    }
}
