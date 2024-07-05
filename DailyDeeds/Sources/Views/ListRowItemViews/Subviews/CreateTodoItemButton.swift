//
//  CreateTodoItemButton.swift
//  DailyDeeds
//
//  Created by Дмитрий Корчагин on 6/23/24.
//

import SwiftUI

struct CreateTodoItemButton: View {
    @State
    var action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Image(systemName: "plus.circle.fill")
                .resizable()
                .scaledToFit()
                .background(.white)
                .frame(width: 44)
                .foregroundColor(.blue)
                .clipShape(.circle)
                .shadow(radius: 5, y: 5)
        }
    }
}
