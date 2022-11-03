import SwiftUI

public enum FontLoader {

    private static let loadFonts: () -> Void = {
        FontFamily.allCases.forEach { loadFont($0.fontsName) }
        return {}
    }()

    private static var fontsLoaded = false

    public static func loadAllAvailableFontsIfNeeded() {
        guard !fontsLoaded else { return }
        fontsLoaded = true
        loadFonts()
    }

    private static func loadFont(_ name: FontFamily.fontExtension) {
        name.fonts.forEach {
            guard
                let fontURL = Bundle.main.url(forResource: $0, withExtension: name.fontExtension),
                  let fontData = try? Data(contentsOf: fontURL) as CFData,
                  let provider = CGDataProvider(data: fontData),
                  let font = CGFont(provider) else {
                return assert(false, "Fonts not loading properly!")
            }
            CTFontManagerRegisterGraphicsFont(font, nil)
        }
    }
}
