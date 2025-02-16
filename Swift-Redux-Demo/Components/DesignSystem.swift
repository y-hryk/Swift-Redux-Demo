//
//  DesignSystem.swift
//  MovieAppDemo
//
//  Created by h.yamaguchi on 2024/09/28.
//

import SwiftUI

extension Font {
    public static func titleLargeS()-> Font {
        .custom("Futura-Medium", size: 20).bold()
    }
    public static func titleM()-> Font {
        .custom("Futura", size: 26).bold()
    }
    public static func titleS()-> Font {
        .custom("Futura", size: 17).bold()
    }
    public static func subTitleL()-> Font {
        .custom("Futura", size: 16).bold()
    }
    public static func subTitleM()-> Font {
        .custom("Futura", size: 14).bold()
    }
    public static func bodyM() -> Font {
        .custom("Futura", size: 16)
    }
    public static func bodyS() -> Font {
        .custom("Futura", size: 14)
    }
    public static func captionL() -> Font {
        .custom("Futura", size: 12).bold()
    }
    public static func captionM() -> Font {
        .custom("Futura", size: 12)
    }
    public static func captionS() -> Font {
        .custom("Futura", size: 10)
    }
    public static func buttonM() -> Font {
        .custom("Futura", size: 16)
    }
}

extension Color {
    func toUIColor() -> UIColor {
        if #available(iOS 14.0, *) {
            return UIColor(self)
        }

        let components = self.components()
        return UIColor(red: components.r, green: components.g, blue: components.b, alpha: components.a)
    }

    private func components() -> (r: CGFloat, g: CGFloat, b: CGFloat, a: CGFloat) {
        let scanner = Scanner(string: self.description.trimmingCharacters(in: CharacterSet.alphanumerics.inverted))
        var hexNumber: UInt64 = 0
        var r: CGFloat = 0.0, g: CGFloat = 0.0, b: CGFloat = 0.0, a: CGFloat = 0.0

        let result = scanner.scanHexInt64(&hexNumber)
        if result {
            r = CGFloat((hexNumber & 0xff000000) >> 24) / 255
            g = CGFloat((hexNumber & 0x00ff0000) >> 16) / 255
            b = CGFloat((hexNumber & 0x0000ff00) >> 8) / 255
            a = CGFloat(hexNumber & 0x000000ff) / 255
        }
        return (r, g, b, a)
    }
}
