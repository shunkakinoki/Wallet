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
      ZStack(alignment: .bottomLeading) {
        WebImage(
          url: URL(
            string: "https://logos.covalenthq.com/tokens/\(token.id).png"
          )
        )
        .resizable()
        .placeholder(content: {
          Text(String(token.symbol ?? ""))
            .font(.custom(font: .inter, size: 12, weight: .light))
            .frame(width: 40, height: 40)
            .background(Color(Colors.Label.secondary))
            .clipShape(Circle())
        })
        .clipShape(Circle())
        .frame(width: 40, height: 40)
        .aspectRatio(contentMode: .fill)
        .padding(.top, 12)
        .padding(.bottom, 12)
        if token.blockchain != "ethereum" {
          Image(token.blockchain)
            .foregroundColor(.white)
            .frame(width: 25, height: 25)
            .clipShape(Circle())
        }
      }
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
