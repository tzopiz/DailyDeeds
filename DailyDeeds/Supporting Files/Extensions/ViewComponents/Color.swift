//
//  Color.swift
//  DailyDeeds
//
//  Created by Дмитрий Корчагин on 6/27/24.
//

import SwiftUI

extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (1, 1, 1, 0)
        }

        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue:  Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
    
    /// Преобразует цвет в HEX строку.
    var hexString: String {
        guard let components = self.cgColor?.components, components.count >= 3
        else { return "" }
        
        let r = Float(components[0])
        let g = Float(components[1])
        let b = Float(components[2])
        
        let hexString = String(
            format: "#%02lX%02lX%02lX",
            lroundf(r * 255),
            lroundf(g * 255),
            lroundf(b * 255)
        )
        
        return hexString
    }
    
    func adjustBrightness(by amount: Double) -> Color {
        var hue: CGFloat = 0
        var saturation: CGFloat = 0
        var brightness: CGFloat = 0
        var alpha: CGFloat = 0

        UIColor(self).getHue(
            &hue,
            saturation: &saturation,
            brightness: &brightness,
            alpha: &alpha
        )
        return Color(
            hue: Double(hue),
            saturation: Double(saturation),
            brightness: amount,
            opacity: Double(alpha)
        )
    }
}
