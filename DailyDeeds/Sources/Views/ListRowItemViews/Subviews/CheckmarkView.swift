//
//  CheckmarkView.swift
//  DailyDeeds
//
//  Created by Дмитрий Корчагин on 6/23/24.
//

import SwiftUI

struct CheckmarkView: View {
    var isDone: Bool
    var importance: Importance
    private var color: Color {
        if isDone {
            return Color.colorGreen
        } else {
            if importance == .high {
                return Color.colorRed
            } else {
                return Color.colorGray
            }
        }
    }
    var body: some View {
        Image(systemName: isDone ? "checkmark.circle.fill" : "circle")
            .resizable()
            .frame(width: 24, height: 24)
            .foregroundStyle(color)
            .background(
                importance == .high ? Color.colorRed.opacity(0.2) : Color.clear
            )
            .clipShape(.circle)
            .padding(.trailing)
            .contentTransition(.symbolEffect(.replace))
    }
}
