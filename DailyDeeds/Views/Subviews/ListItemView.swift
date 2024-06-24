//
//  ListItemView.swift
//  DailyDeeds
//
//  Created by Дмитрий Корчагин on 6/22/24.
//

import SwiftUI

struct ListItemView: View {
    
    let item: TodoItem
    
    var body: some View {
        HStack {
            CheckmarkView(isDone: item.isDone, importance: item.importance)
            VStack(alignment: .leading) {
                HStack {
                    ImportanceView(importance: item.importance)
                    textView
                }
                if let deadline = item.deadline {
                    HStack {
                        Image(systemName: "calendar")
                        Text(deadline, style: .date)
                            .font(.subheadline)
                    }
                    .foregroundColor(Res.Color.Label.secondary)
                }
            }
            Image(systemName: "chevron.right")
                .foregroundStyle(Res.Color.gray)
        }
        .padding([.top, .bottom], 8)
    }
    
    private var textView: some View {
        Text(item.text)
            .font(.headline)
            .lineLimit(3)
            .foregroundColor(
                item.isDone ? Res.Color.Label.disable : Res.Color.Label
                    .primary
            )
            .strikethrough(item.isDone, color: Res.Color.Label.disable)
    }
}

#Preview {
    let item = TodoItemViewModel.createTodoItems(10)
    ListItemView(item: item[Int.random(in: 0..<10)])
}
