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
          Text(String(transaction.name.first ?? Character("")))
            .frame(width: 40, height: 40)
            .background(Color(Colors.Background.primary))
            .clipShape(Circle())
        })
        .frame(width: 40, height: 40)
        .aspectRatio(contentMode: .fill)
        .padding([.top, .bottom], 12)
      VStack(alignment: .leading, spacing: 4) {
        Text("$\(transaction.value.hashValue)")
          .foregroundColor(Color(Colors.Background.primary))
          .font(.custom(font: .inter, size: 17, weight: .regular))
        Text(transaction.assetCode)
          .font(.custom(font: .inter, size: 13, weight: .medium))
      }.padding(.leading, 4)
      Spacer()
      Text("\(transaction.quantity) \(transaction.assetCode.uppercased())")
        .foregroundColor(Color(Colors.System.secondary))
        .font(.custom(font: .inter, size: 14, weight: .semibold))
    }.padding(.leading, 12).padding(.trailing, 24)
  }
}
