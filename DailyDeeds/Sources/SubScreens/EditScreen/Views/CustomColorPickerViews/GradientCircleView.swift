//
//  GradientCircleView.swift
//  DailyDeeds
//
//  Created by Дмитрий Корчагин on 6/30/24.
//
import SwiftUI

struct GradientCircleView: View {
    let fillColor: Color
    let separatorColor: Color
    var body: some View {
        ZStack {
            ColorGradientCircleView()
            Circle()
                .fill(fillColor)
                .overlay(
                    Circle()
                        .strokeBorder(
                            separatorColor,
                            lineWidth: 2
                        )
                )
                .frame(width: 32, height: 32)
        }
    }
}
