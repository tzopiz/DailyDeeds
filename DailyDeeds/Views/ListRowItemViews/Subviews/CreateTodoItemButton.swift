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
                .background(Res.Color.white)
                .clipShape(.circle)
                .frame(width: 44, height: 44)
        }
        .shadow(radius: 7, x: 0, y: 5)
    }
}

#Preview {
    CreateTodoItemButton {
        print(#function)
    }
}
