//
//  ColorPalette.swift
//  DailyDeeds
//
//  Created by Дмитрий Корчагин on 6/29/24.
//

import SwiftUI

struct ColorPalette: View {
    var body: some View {
        Canvas { context, size in
            for x in stride(from: 0, to: size.width, by: 1) {
                for y in stride(from: 0, to: size.height, by: 1) {
                    let color = UIColor(
                        hue: x / size.width,
                        saturation: y / size.height,
                        brightness: 1.0,
                        alpha: 1
                    )
                    context.fill(Path(CGRect(x: x, y: y, width: 1, height: 1)), with: .color(Color(color)))
                }
            }
        }
    }
}
