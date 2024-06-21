//
//  TestEscapeSpecialCharacters.swift
//  DailyDeedsTests
//
//  Created by Дмитрий Корчагин on 6/20/24.
//

import XCTest
@testable import DailyDeeds

final class TestEscapeSpecialCharacters: XCTestCase {
    
    func testEscapeSpecialCharacters() {
        let text = "text, where user use comma."
        let newText = text.escapeSpecialCharacters(",")
        XCTAssertEqual(newText, "text\\, where user use comma.")
    }
    
    func testUnescapeSpecialCharacters() {
        let text = "text\\, where user use comma."
        let newText = text.unescapeSpecialCharacters(",")
        XCTAssertEqual(newText, "text, where user use comma.")
    }
    
    func testFullCycle() {
        let text = "text, where user use comma."
        let escapeText = text.escapeSpecialCharacters(",")
        let unescapeText = escapeText.unescapeSpecialCharacters(",")
        XCTAssertEqual(text, unescapeText)
    }
    
    func testSplitByUnescaped() {
        let text = "text, where user use comma."
        let escapeText = text.escapeSpecialCharacters(",")
        let splitText = escapeText.splitByUnescaped(separator: ",")
        XCTAssertEqual(splitText, [text])
    }
}
