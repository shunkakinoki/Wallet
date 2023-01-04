import Commons
import Domain
import Foundation
import Keychain
import Session
import SwiftUI

public final class WalletEditViewModel: ObservableObject {

  private let account: EthereumAccount
  private let selectedWallet: SelectedWallet
  private let changeSelectedName: ChangeSelectedWalletProperties

  @State
  public var selected: String = ""

  public init(
    account: EthereumAccount = EthereumAccount(),
    selectedWallet: SelectedWallet = SelectedWalletImp(),
    changeSelectedName: ChangeSelectedWalletProperties = ChangeSelectedWalletPropertiesImp()
  ) {
    self.account = account
    self.selectedWallet = selectedWallet
    self.changeSelectedName = changeSelectedName
  }

  public func getName() -> String {
    do {
      let wallet = try selectedWallet.selected()
      return wallet.name
    } catch {
      return ""
    }
  }

  public func getColor() -> String {
    do {
      let wallet = try selectedWallet.selected()
      return wallet.color.rawValue
    } catch {
      return ""
    }
  }

  public func getColors() -> [String] {
    ["green", "indigo", "orange", "pink", "purple", "red", "teal", "yellow"]
  }

  public func editName(_ name: String) {
    do {
      try changeSelectedName.changeName(name)
    } catch {
      print(error)
    }
  }

  public func editColor(_ rawColor: String) {
    do {
      let color = EthereumWalletColor(rawValue: rawColor) ?? .green
      try changeSelectedName.changeColor(color)
    } catch {
      print(error)
    }
  }
}
