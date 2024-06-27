//
//  CreateNewTodoItemRowView.swift
//  DailyDeeds
//
//  Created by Дмитрий Корчагин on 6/27/24.
//

import SwiftUI

struct CreateNewTodoItemRowView: View {
    @State
    var text: String
    var createItem: (String) -> Void
    
    @Environment(\.scenePhase)
    private var phase
    
    var body: some View {
        HStack(spacing: 8) {
            CheckmarkView(isDone: false, importance: .medium)
                .hidden()
            TextField("Новое", text: $text)
                .frame(height: 56)
                .font(.subheadline)
                .foregroundStyle(Res.Color.Label.primary)
                .onSubmit {
                    createItem(text)
                    text = ""
                }
        }
    }
}
