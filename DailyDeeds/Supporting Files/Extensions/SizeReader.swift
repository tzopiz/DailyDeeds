//
//  SizeReader.swift
//  DailyDeeds
//
//  Created by Дмитрий Корчагин on 6/25/24.
//

import SwiftUI

struct SizeReader: ViewModifier {
    let listener: (CGSize) -> Void
    func body(content: Content) -> some View {
        content
            .background {
                GeometryReader { reader in
                    let _ = listener(reader.size)
                    Color.clear
                }
            }
    }
}

extension View {
    func readSize(listener: @escaping (CGSize) -> Void) -> some View {
        self.modifier(SizeReader(listener: listener))
    }
}
