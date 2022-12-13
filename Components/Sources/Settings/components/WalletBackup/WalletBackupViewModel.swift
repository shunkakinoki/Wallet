import Commons
import Domain
import Foundation
import Keychain
import Session
import SwiftUI

public final class WalletBackupViewModel: ObservableObject {

  private let account: EthereumAccount
  private let selectedWallet: SelectedWallet
  private let address: String

  public convenience init() {
    self.init(account: EthereumAccount(), selectedWallet: SelectedWalletImp())
  }

  private init(account: EthereumAccount, selectedWallet: SelectedWallet) {
    self.account = account
    self.selectedWallet = selectedWallet
    self.address = try! selectedWallet.selected().address.eip55Description
  }

  public func ethereumAddress() -> String {
    address
  }

  public func hasPrivateKey() -> Bool {
    return true
  }

  public func hasSeedPhrase() -> Bool {
    do {
      let address = try selectedWallet.selected().address.eip55Description
      let seedPhrases = try account.fetchSeeds().compactMap { $0 }
      guard
        let seedPhrase = seedPhrases.first(
          where: { $0.addresses.containsValue(value: address) }
        )
      else {
        return false
      }
      return seedPhrase.cipherText.count > 0
    } catch {
      return false
    }
  }
}
