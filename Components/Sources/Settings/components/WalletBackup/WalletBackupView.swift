import Foundation
import SwiftUI
import Session
import Domain
import Keychain
import Commons

public struct WalletBackupView: View {

    @ObservedObject
    var viewModel: WalletBackupViewModel

    public init(viewModel: WalletBackupViewModel = WalletBackupViewModel()) {
        self.viewModel = viewModel
    }

    public var body: some View {
        VStack(spacing: 0) {
            Form {
                ZStack {
                    VStack(spacing: 0) {
                        HStack {
                            Text("Keychain")
                                .foregroundColor(Color(Colors.Label.primary))
                                .font(.system(size: 17, weight: .semibold))
                                .padding(.top, 8)
                            Spacer()
                        }
                        HStack {
                            Text("Your recovery phrase and private keys are stored securely on device with Apple's Secure Enclave. If you delete Light and reinstall it, you will not have access to your accounts.")
                                .lineLimit(nil)
                                ._lineHeightMultiple(1.08)
                                .foregroundColor(Color(Colors.Label.secondary))
                                .padding([.top, .bottom], 8)
                                .font(.system(size: 17, weight: .regular))
                            Spacer()
                        }
                    }
                }
                Section {
                    if viewModel.hasSeedPhrase() {
                        NavigationLink(destination: ShowSeedPhraseView(viewModel: ShowSeedPhraseViewModel(address: viewModel.ethereumAddress()))) {
                            HStack(spacing: 16) {
                                Image("SeedPhraseIcon")
                                Text("Recovery Phrase")
                                    .font(.custom(font: .inter, size: 17, weight: .regular))
                            }
                            .padding([.top, .bottom], 2.5)
                        }
                    }
                    if viewModel.hasPrivateKey() {
                        NavigationLink(destination: ShowPrivateKeyView(viewModel: ShowPrivateKeyViewModel(address: viewModel.ethereumAddress()))) {
                            HStack(spacing: 16) {
                                Image("PrivateKeyIcon")
                                Text("Private Key")
                                    .font(.custom(font: .inter, size: 17, weight: .regular))
                            }
                            .padding([.top, .bottom], 2.5)
                        }
                    }
                } header: {
                    Text("MANUAL".uppercased())
                        .font(.system(size: 12, weight: .medium))
                }
            }
        }
        .navigationBarTitle("Backup", displayMode: .inline)
    }
}
