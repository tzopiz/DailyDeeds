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
    
    var body: some View {
        if isDone {
            Image(systemName: "checkmark.circle.fill")
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
}

#Preview {
    CheckmarkView(isDone: false, importance: .low)
        .padding()
        .background(Rectangle().stroke(Color.black))
    CheckmarkView(isDone: false, importance: .medium)
        .padding()
        .background(Rectangle().stroke(Color.black))   
    CheckmarkView(isDone: false, importance: .high)
        .padding()
        .background(Rectangle().stroke(Color.black))  
    CheckmarkView(isDone: true, importance: .low)
        .padding()
        .background(Rectangle().stroke(Color.black))   
    CheckmarkView(isDone: true, importance: .medium)
        .padding()
        .background(Rectangle().stroke(Color.black))   
    CheckmarkView(isDone: true, importance: .high)
        .padding()
        .background(Rectangle().stroke(Color.black))
}

