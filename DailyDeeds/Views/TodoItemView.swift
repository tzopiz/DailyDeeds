//
//  TodoItemView.swift
//  DailyDeeds
//
//  Created by Дмитрий Корчагин on 6/22/24.
//

import SwiftUI

struct TodoItemView: View {
    
    let item: TodoItem
    
    var body: some View {
        HStack {
            isDoneImage(item.isDone, importance: item.importance)
            VStack(alignment: .leading) {
                HStack {
                    importanceView
                    textView
                }
                deadlineView
            }
        }
        .padding([.top, .bottom], 8)
    }
    
    private var textView: some View {
        Text(item.text)
            .font(.headline)
            .lineLimit(3)
    }
    
    private let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        return formatter
    }()
    
    @ViewBuilder
    private func isDoneImage(_ isDone: Bool, importance: Importance) -> some View {
        if isDone {
            Image(systemName: item.isDone ? "checkmark.circle.fill" : "circle")
                .resizable()
                .frame(width: 24, height: 24)
                .foregroundStyle(Res.Color.green)
                .padding(.trailing)
        } else {
            Image(systemName: "circle")
                .resizable()
                .frame(width: 24, height: 24)
                .foregroundStyle(
                    importance == .high ? Res.Color.red : Res.Color.gray
                )
                .background(
                    importance == .high ? Res.Color.red.opacity(0.2) : Res.Color.clear
                )
                .clipShape(Circle())
                .padding(.trailing)
        }
    }
    
    @ViewBuilder
    private var deadlineView: some View {
        if let deadline = item.deadline {
            HStack {
                Image(systemName: "calendar")
                Text("\(deadline, formatter: dateFormatter)")
                    .font(.subheadline)
                    .foregroundColor(.gray)
            }
        }
    }
    
    @ViewBuilder
    private var importanceView: some View {
        if item.importance == .high {
            Text(Image(systemName: "exclamationmark.2"))
                .foregroundStyle(Color.red)
                .bold()
        }
    }
}
