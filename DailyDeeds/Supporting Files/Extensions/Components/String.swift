//
//  String.swift
//  DailyDeeds
//
//  Created by Дмитрий Корчагин on 6/17/24.
//

import Foundation

extension String {
    func toDate(format: String = "yyyy-MM-dd HH:mm:ss") -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        return dateFormatter.date(from: self)
    }
    
    func escapeSpecialCharacters(_ chars: Character...) -> String {
        return chars.reduce(into: self) { partialResult, char in
            partialResult = partialResult.replacingOccurrences(of: String(char), with: "\\\(char)")
        }
    }
    
    func unescapeSpecialCharacters(_ chars: Character...) -> String {
        return chars.reduce(into: self) { partialResult, char in
            partialResult = partialResult.replacingOccurrences(of: "\\\(char)", with: String(char))
        }
    }
    
    func splitByUnescaped(separator: Character) -> [String] {
        // Создаем регулярное выражение для поиска разделителя, не предшествующего обратному слэшу
        let escapedSeparator = NSRegularExpression.escapedPattern(for: String(separator))
        let pattern = "(?<!\\\\)" + escapedSeparator
        guard let regex = try? NSRegularExpression(pattern: pattern) else { return [] }
        
        let range = NSRange(self.startIndex..<self.endIndex, in: self)
        let matches = regex.matches(in: self, range: range)
        
        var results: [String] = []
        var lastIndex = self.startIndex
        
        for match in matches {
            guard let matchRange = Range(match.range, in: self) else { continue }
            let substring = self[lastIndex..<matchRange.lowerBound]
            results.append(String(substring))
            lastIndex = matchRange.upperBound
        }
        
        results.append(String(self[lastIndex...]))
        results = results.map { $0.unescapeSpecialCharacters(separator) }
        
        return results
    }
}
