import Commons
import Foundation
import SwiftUI

public struct WalletSelector: View {

  private let walletColor: String
  private let walletName: String
  private let walletAddress: String

  public init(walletColor: String, walletName: String, walletAddress: String) {
    self.walletColor = walletColor
    self.walletName = walletName
    self.walletAddress = walletAddress
  }

  public var body: some View {
    WalletSelectorIcon(walletColor: walletColor)
    VStack(alignment: .leading, spacing: 1) {
      HStack {
        Text(walletName)
          .font(.custom(font: .inter, size: 18, weight: .bold))
          .foregroundColor(Color(Colors.Label.primary))
        Image(systemName: "chevron.up.chevron.down")
          .frame(width: 24, height: 24)
          .foregroundColor(Color(Colors.Label.primary))
      }
      Text(walletAddress)
        .foregroundColor(Color(Colors.Label.secondary))
        .font(.custom(font: .inter, size: 14, weight: .medium))
        .frame(alignment: .leading)
    }
  }
}
