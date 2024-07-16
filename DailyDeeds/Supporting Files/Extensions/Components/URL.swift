//
//  URL.swift
//  DailyDeeds
//
//  Created by Дмитрий Корчагин on 7/16/24.
//

import Foundation

extension URL {
    func appending(queryItems: [URLQueryItem]) -> URL {
        guard var components = URLComponents(url: self, resolvingAgainstBaseURL: true) else {
            return self
        }
        components.queryItems = (components.queryItems ?? []) + queryItems
        return components.url ?? self
    }
}
