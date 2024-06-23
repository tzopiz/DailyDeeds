//
//  ImportanceView.swift
//  DailyDeeds
//
//  Created by Дмитрий Корчагин on 6/23/24.
//

import SwiftUI

struct ImportanceView: View {
    @State
    var importance: Importance
    
    var body: some View {
        if importance == .high {
            Text(Image(systemName: "exclamationmark.2"))
                .foregroundStyle(Res.Color.red)
                .bold()
        } else if importance == .low {
            Text(Image(systemName: "arrow.down"))
                .foregroundStyle(Res.Color.gray)
                .bold()
        }
    }
}

#Preview {
    ImportanceView(importance: .low)
        .padding()
        .background(Rectangle().stroke(Color.green))
    ImportanceView(importance: .medium)
        .padding()
        .background(Rectangle().stroke(Color.green))
    ImportanceView(importance: .high)
        .padding()
        .background(Rectangle().stroke(Color.green))
}
