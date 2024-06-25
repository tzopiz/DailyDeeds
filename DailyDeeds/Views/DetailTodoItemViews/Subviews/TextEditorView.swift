//
//  TextEditorView.swift
//  DailyDeeds
//
//  Created by Дмитрий Корчагин on 6/23/24.
//

import SwiftUI

struct TextEditorView: View {
    
    @Binding
    var text: String
    @State
    var textEditorHeight : CGFloat = 120
    
    var body: some View {
        ZStack(alignment: .leading) {
            Text(text)
                .font(.system(.body))
                .foregroundColor(.clear)
                .padding(10)
                .background(
                    GeometryReader {
                        Color.clear.preference(
                            key: ViewHeightKey.self,
                            value: $0.frame(in: .local).size.height
                        )
                })
            
            TextEditor(text: $text)
                .font(.system(.body))
                .frame(height: max(40,textEditorHeight))
                .cornerRadius(10.0)
                .shadow(radius: 1.0)
        }
        .onPreferenceChange(ViewHeightKey.self) {
            textEditorHeight = $0
        }
    }
}


struct ViewHeightKey: PreferenceKey {
    static var defaultValue: CGFloat { 0 }
    static func reduce(value: inout Value, nextValue: () -> Value) {
        value = value + nextValue()
    }
}
