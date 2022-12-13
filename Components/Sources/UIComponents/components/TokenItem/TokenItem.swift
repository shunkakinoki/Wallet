import Commons
import Foundation
import SDWebImageSwiftUI
import SwiftUI
import TokenServices

public struct TokenItem: View {
  @State var token: Token

  public init(token: Token) {
    self.token = token
  }

  public var body: some View {
    HStack {
      WebImage(url: URL(string: "https://picsum.photos/200/300"))
        .resizable()
        .placeholder(content: {
          Text(String(token.name ?? ""))
            .frame(width: 40, height: 40)
            .background(Color(Colors.Label.primary))
            .clipShape(Circle())
        })
        .frame(width: 40, height: 40)
        .aspectRatio(contentMode: .fill)
        .padding(.top, 12)
        .padding(.bottom, 12)
      VStack(alignment: .leading, spacing: 4) {
        Text("$\(String(format: "%.02f", Double(truncating: token.value as NSNumber)))")
          .foregroundColor(Color(Colors.Label.primary))
          .font(.custom(font: .inter, size: 17, weight: .regular))
        Text(token.symbol)
          .font(.custom(font: .inter, size: 13, weight: .medium))
      }.padding(.leading, 4)
      Spacer()
      Text("\(token.amount) \(token.symbol.uppercased())")
        .foregroundColor(Color(Colors.Label.secondary))
        .font(.custom(font: .inter, size: 14, weight: .semibold))
    }.padding(.leading, 7.5).padding(.trailing, 7.5)
  }
}
