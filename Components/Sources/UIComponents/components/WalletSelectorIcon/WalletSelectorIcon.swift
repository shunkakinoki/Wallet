import SwiftUI

public struct WalletSelectorIcon: View {
  private let walletColor: String

  public init(walletColor: String) {
    self.walletColor = walletColor
  }

  public var body: some View {
    Image(walletColor)
      .resizable()
      .aspectRatio(contentMode: .fill)
      .frame(width: 48, height: 48)
      .clipShape(Circle())

  }
}
