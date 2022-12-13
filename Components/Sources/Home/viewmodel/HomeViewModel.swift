import AddressServices
import Combine
import Domain
import Foundation
import Session
import SwiftUI
import TokenServices
import UIKit

public final class HomeViewModel: ObservableObject {

  private let selectedWallet: SelectedWallet
  private let getAddress: GetAddress
  private let getHostConfiguration: GetHostConfiguration
  private let getTokens: GetTokens

  private var subscriptions = Set<AnyCancellable>()

  @Published
  var address: Address = Address.addressDefault

  @Published
  var tokens = [Token]()

  @Published
  var configurations = [HostConfigurationModel.HostConfigurationParameters]()

  @Published
  var selectedRawAddress: String = ""

  @Published
  var selectedAddress: String = ""

  @Published
  var color: String = ""

  @Published
  var name: String = ""

  init(
    selectedWallet: SelectedWallet = SelectedWalletImp(),
    getAddress: GetAddress = GetAddressImp(),
    getHostConfiguration: GetHostConfiguration = GetHostConfigurationImp(),
    getTokens: GetTokens = GetTokensImp()
  ) {
    self.selectedWallet = selectedWallet
    self.getAddress = getAddress
    self.getHostConfiguration = getHostConfiguration
    self.getTokens = getTokens

    self.getWalletAddress()
  }

  public func getWalletSelected() {
    do {
      let walletSelected = try selectedWallet.selected()
      self.selectedAddress = walletSelected.address.eip55Description.addressFormat()
      self.selectedRawAddress = walletSelected.address.eip55Description
      self.name = walletSelected.name
      self.color = walletSelected.color.rawValue
    } catch {
      self.selectedRawAddress = ""
      self.selectedAddress = ""
      self.name = ""
    }
  }

  public func getConfiguration() {
    self.configurations = []
    if let configurations = getHostConfiguration.get() {
      self.configurations.append(contentsOf: configurations)
    }
  }

  @MainActor
  public func getTokensList() async {
    do {
      self.tokens = try await getTokens.get()
    } catch {
      self.tokens = []
    }
  }

  public func getWalletAddress() {
    getAddress.invoke()
      .replaceError(with: Address.addressDefault)
      .assign(to: \.address, on: self)
      .store(in: &subscriptions)
  }

  public func getChainImage(chainId: String) -> String {
    return retrieveChainName(with: chainId)
  }

  func retrieveChainName(with chainId: String) -> String {
    switch chainId {
    case "0x1":
      return "ethereum"
    case "0x5":
      return "goerli"
    case "0xa":
      return "optimism"
    case "0x89":
      return "polygon"
    case "0xa4b1":
      return "arbitrum"
    default:
      return "ethereum"
    }
  }
}
