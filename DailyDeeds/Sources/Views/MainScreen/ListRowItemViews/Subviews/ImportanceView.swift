//
//  ImportanceView.swift
//  DailyDeeds
//
//  Created by Дмитрий Корчагин on 6/23/24.
//

import SwiftUI

struct ImportanceView: View {
    
    var importance: Importance
    
    private var imageName: String {
        switch importance {
        case .low: "arrow.down"
        case .high: "exclamationmark.2"
        default: ""
        }
    }
    private var color: Color {
        switch importance {
        case .low: return Res.Color.lightGray
        case .medium: return Color.clear
        case .high: return Res.Color.red
        }
    }
    
    var body: some View {
        if importance != .medium {
            Text(Image(imageName))
        }
    }
}
