import Commons
import SDWebImageSwiftUI
import SwiftUI
import TransactionServices

public struct TransactionItem: View {
  @State var transaction: TransactionStruct

  public init(
    transaction: TransactionStruct
  ) {
    self.transaction = transaction
  }

  public var body: some View {
    HStack {
      WebImage(url: URL(string: transaction.image))
        .resizable()
        .placeholder(content: {
          Text(String(transaction.action))
            .frame(width: 40, height: 40)
            .clipShape(Circle())
        })
        .frame(width: 40, height: 40)
        .aspectRatio(contentMode: .fill)
        .padding([.top, .bottom], 12)
      VStack(alignment: .leading, spacing: 4) {
        Text(transaction.action)
          .foregroundColor(Color(Colors.Label.primary))
          .font(Font.system(size: 17, weight: .regular))
          ._lineHeightMultiple(1.09)
        Text(transaction.id)
          .foregroundColor(Color(Colors.Label.secondary))
          .font(Font.system(size: 12, weight: .regular))
          ._lineHeightMultiple(1.12)
      }.padding(.leading, 4)
      Spacer()
      Text("Here")
        .foregroundColor(Color(Colors.System.secondary))
        .font(.custom(font: .inter, size: 14, weight: .semibold))
    }.padding(.leading, 12).padding(.trailing, 24)
  }
}
