//
//  ListRowItemView.swift
//  DailyDeeds
//
//  Created by Дмитрий Корчагин on 6/22/24.
//

import SwiftUI

struct ListRowItemView: View {
    
    let item: TodoItem
    
    var body: some View {
        HStack {
            CheckmarkView(isDone: item.isDone, importance: item.importance)
            ImportanceView(importance: item.importance)
            
            VStack(alignment: .leading) {
                textView
                deadlineView
            }
            
            Spacer()
            
            Image(systemName: "chevron.right")
                .foregroundStyle(Color.colorLightGray)
            
            RoundedRectangle(cornerRadius: 5)
                .frame(width: 5)
                .foregroundStyle(Color(hex: item.hexColor).gradient)
        }
        .contentShape(.rect)
    }
    
    @ViewBuilder
    private var deadlineView: some View {
        if let deadline = item.deadline {
            HStack {
                Image(systemName: "calendar")
                Text(deadline, style: .date)
                    .font(.subheadline)
                    .foregroundStyle(Color.labelTertiary)
            }
            .foregroundColor(Color.labelSecondary)
        }
    }
    
    private var textView: some View {
        Text(item.text)
            .lineLimit(3)
            .multilineTextAlignment(.leading)
            .font(.system(size: 17))
            .foregroundColor(
                item.isDone ? Color.labelDisable : Color.labelPrimary
            )
            .strikethrough(item.isDone)
    }
}
