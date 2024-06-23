//
//  DeadlineView.swift
//  DailyDeeds
//
//  Created by Дмитрий Корчагин on 6/23/24.
//

import SwiftUI

struct DeadlineView: View {
    @State
    var deadline: Date?
    
    var body: some View {
        if let deadline = deadline {
            HStack {
                Image(systemName: "calendar")
                Text("\(deadline, formatter: dateFormatter)")
                    .font(.subheadline)
            }
            .foregroundColor(Res.Color.Label.secondary)
        }
    }
    
    fileprivate let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        return formatter
    }()
    
}

#Preview {
    DeadlineView(deadline: .now.tomorrow)
}
