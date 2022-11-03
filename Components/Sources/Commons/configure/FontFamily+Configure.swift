import Foundation
import UIKit
import SwiftUI

public enum FontFamily: String, CaseIterable {
    public typealias fontExtension = (fontExtension: String, fonts: [String])

    case inter = "Inter"

    public var validWeights: [FontWeight] {
        switch self {
        case .inter:
            return FontWeight.allCases
        }
    }

    public var fontsName: fontExtension {
        switch self {
        case .inter:
            return ("ttf", FontFamily.inter.validWeights.map { self.rawValue + $0.rawValue })
        }
    }
}

public enum FontWeight: String, CaseIterable {
    case bold = "-Bold"
    case extralight = "-ExtraLight"
    case light = "-Light"
    case medium = "-Medium"
    case regular = "-Regular"
    case semibold = "-SemiBold"
    case black = "-Black"
    case extraBold = "-ExtraBold"
    case thin = "-Thin"
}

public extension Font {
    static func custom(font: FontFamily, size: CGFloat, weight: FontWeight) -> Font {
        Font.custom(font.rawValue + weight.rawValue, size: size)
    }
}

public extension UIFont {
    static func custom(font: FontFamily, size: CGFloat, weight: FontWeight) -> UIFont {
        guard let customFont = UIFont(name: font.rawValue + weight.rawValue, size: size) else {
            return UIFont.systemFont(ofSize: size, weight: .medium)
        }
        return customFont
    }
}
