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
    
    private var imageName: String {
        switch importance {
        case .low: "arrow.down"
        case .high: "exclamationmark.2"
        default: ""
        }
    }
    
    var body: some View {
        if importance != .medium {
            Text(Image(imageName))
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
