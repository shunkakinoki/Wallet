import Commons
import SwiftUI

public struct EmptyItem: View {

  public let title: String

  public init(title: String) {
    self.title = title
  }

  public var body: some View {
    VStack {
      HStack {
        Text(title)
          .foregroundColor(Color(Colors.System.secondary))
          .frame(maxWidth: .infinity, alignment: .leading)
          .padding(.leading, 14)
      }
      HStack {
        VStack {
          Text("Empty")
            .foregroundColor(Color(Colors.System.secondary))
            .font(.custom(font: .inter, size: 16, weight: .regular))
        }
        .frame(width: 130, height: 130)
        .clipShape(RoundedRectangle(cornerRadius: 15))
        .overlay(
          RoundedRectangle(cornerRadius: 12)
            .stroke(
              Color(Colors.System.primary),
              lineWidth: 1.5)
        )
        Spacer()
      }.padding(.leading, 15)
    }
  }
}
