import SwiftUI

public struct ColoredIconView: View {

    let imageName: String
    let foregroundColor: Color
    let backgroundColor: Color

    public init(imageName: String, foregroundColor: Color, backgroundColor: Color) {
        self.imageName = imageName
        self.foregroundColor = foregroundColor
        self.backgroundColor = backgroundColor
    }

    public var body: some View {
        Image(systemName: imageName)
            .resizable()
            .scaledToFit()
            .padding(6.0)
            .frame(width: 30, height: 30)
            .foregroundColor(foregroundColor)
            .background(backgroundColor)
            .cornerRadius(7.0)
    }
}
