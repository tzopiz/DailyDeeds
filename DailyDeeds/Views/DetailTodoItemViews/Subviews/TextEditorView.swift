//
//  TextEditorView.swift
//  DailyDeeds
//
//  Created by Дмитрий Корчагин on 6/23/24.
//

import SwiftUI

struct TextEditorView: View {
    @State
    var text: String
    
    var body: some View {
        TextEditor(text: $text)
            .font(.system(size: 16))
    }
}

#Preview {
    TextEditorView(text: "123")
        .padding()
        .background(Res.Color.Back.iOSPrimary)
}
