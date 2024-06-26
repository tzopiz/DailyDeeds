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
            Color(hex: item.hexColor)
                .frame(width: 5)
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
            Spacer(minLength: 4)
            Image(systemName: "chevron.right")
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
            .strikethrough(item.isDone)
    }
}

#Preview {
    let item = TodoItemViewModel.createTodoItems(10)
    ListItemView(item: item[Int.random(in: 0..<10)])
}
