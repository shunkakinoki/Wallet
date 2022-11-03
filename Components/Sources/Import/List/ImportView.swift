import Foundation
import SwiftUI
import Commons
import UIComponents

public struct ImportView: View {

    @Environment(\.presentationMode)
    var presentationMode

    public init() { }

    public var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                HStack {
                    Text("Choose how you would like to import your wallet")
                        .font(.system(size: 13, weight: .regular))
                        .foregroundColor(Color(Colors.Label.secondary))
                        .padding(.leading, 16)
                    Spacer()
                }.padding(.top, 23)
                VStack {
                    NavigationLink(destination: ImportHDWalletView()) {
                        ImportViewCategoryItem(icon: ["SeedPhraseIcon"], title: "With Recovery Phrase", description: "Import wallets with a 12 word recovery phrase")
                    }
                    NavigationLink(destination: ImportPrivateKeyView()) {
                        ImportViewCategoryItem(icon: ["PrivateKeyIcon"], title: "With Private Key", description: "Import a wallet by entering its private key.")
                    }
                }.padding(.top, 8)
                Spacer()
            }
            .navigationBarTitle("Import or Restore Wallet", displayMode: .inline)
            .toolbar { CloseToolbar { presentationMode.wrappedValue.dismiss() } }
        }
    }
}
