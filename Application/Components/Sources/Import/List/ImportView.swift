import Commons
import Foundation
import SwiftUI
import UIComponents

public struct ImportView: View {

  private let primary: Bool

  @Environment(\.presentationMode)
  var presentationMode

  public init(primary: Bool = false) {
    self.primary = primary
  }

  public var body: some View {
    NavigationView {
      ScrollView {
        VStack(spacing: 0) {
          HStack {
            Text("Choose how you would like to import your wallet")
              .font(.system(size: 13, weight: .regular))
              .foregroundColor(Color(Colors.Label.secondary))
              .padding(.leading, 16)
            Spacer()
          }.padding(.top, 23)
          VStack(spacing: 16) {
            NavigationLink(destination: ImportHDWalletView(primary: self.primary)) {
              ImportViewCategoryItem(
                icon: "ellipsis.rectangle.fill", color: Color(Colors.System.purple),
                title: "With Recovery Phrase",
                description: "Import wallets with a 12 word recovery phrase")
            }
            NavigationLink(destination: ImportPrivateKeyView()) {
              ImportViewCategoryItem(
                icon: "key.fill", color: Color(Colors.System.orange), title: "With Private Key",
                description: "Import a wallet by entering its private key.")
            }
          }.padding(.top, 8).padding([.leading, .trailing], 16)
          Spacer()
        }
        .navigationBarTitle("Import or Restore Wallet", displayMode: .inline)
        .toolbar { CloseToolbar { presentationMode.wrappedValue.dismiss() } }
      }
    }
  }
}
