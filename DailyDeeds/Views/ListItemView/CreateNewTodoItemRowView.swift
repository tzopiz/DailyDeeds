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
    
    @Environment(\.scenePhase)
    private var phase
    
    var body: some View {
        HStack(spacing: 8) {
            TextField("New daily deels", text: $text)
                .lineLimit(1...3) // FIXME: - line limit = 3 ???
                .font(.subheadline)
                .foregroundStyle(.primary)
                .padding(.leading, 50)
                .padding([.trailing, .top, .bottom])
                .onChange(of: phase) { oldValue, newValue in
                    if newValue != .active, text.isEmpty {
                        // TODO: - delete empty item
                    }
                }
                .onSubmit {
                    // TODO: - add new item
                }
        }
    }
}
