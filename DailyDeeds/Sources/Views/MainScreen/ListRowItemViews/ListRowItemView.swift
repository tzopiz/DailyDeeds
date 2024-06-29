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
                .foregroundStyle(Res.Color.lightGray)
            
            RoundedRectangle(cornerRadius: 5)
                .frame(width: 5)
                .foregroundStyle(Color(hex: item.hexColor).gradient)
        }
    }
    
    @ViewBuilder
    private var deadlineView: some View {
        if let deadline = item.deadline {
            HStack {
                Image(systemName: "calendar")
                Text(deadline, style: .date)
                    .font(.subheadline)
                    .foregroundStyle(Res.Color.Label.tertiary)
            }
            .foregroundColor(Res.Color.Label.secondary)
        }
    }
    
    private var textView: some View {
        Text(item.text)
            .lineLimit(3)
            .multilineTextAlignment(.leading)
            .font(.system(size: 17))
            .foregroundColor(
                item.isDone ? Res.Color.Label.disable : Res.Color.Label
                    .primary
            )
            .strikethrough(item.isDone)
    }
}
