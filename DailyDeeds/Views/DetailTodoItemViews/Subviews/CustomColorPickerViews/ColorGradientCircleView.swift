//
//  ColorGradientCircleView.swift
//  DailyDeeds
//
//  Created by Дмитрий Корчагин on 6/29/24.
//

import SwiftUI

struct ColorGradientCircleView: View {
    var body: some View {
        ZStack {
            Circle()
                .fill(
                    AngularGradient(
                        gradient: Gradient(colors: [.red, .yellow, .green, .blue, .purple, .red]),
                        center: .center
                    )
                )
                .frame(width: 40, height: 40)
                .shadow(radius: 3)
        }
    }
}
