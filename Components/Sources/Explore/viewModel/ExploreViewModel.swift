import Combine
import DappServices
import Domain
import Foundation
import Services
import SwiftUI
import UIKit

public final class HomeViewModel: ObservableObject {

  private let getHostConfiguration: GetHostConfiguration
  private let getDapps: GetDapps

  private var subscriptions = Set<AnyCancellable>()

  @Published
  var tokens = [Token]()

  @Published
  var configurations = [HostConfigurationModel.HostConfigurationParameters]()

  @Published
  var isLoading = true

  @Published
  var isValidating = false

  init(
    getHostConfiguration: GetHostConfiguration = GetHostConfigurationImp(),
    getDapps: GetDapps = GetDappsImp()
  ) {
    self.getHostConfiguration = getHostConfiguration
    self.getDapps = getDapps

    self.getWalletAddress()
  }

  public func getConfiguration() {
    self.configurations = []
    if let configurations = getHostConfiguration.get() {
      self.configurations.append(contentsOf: configurations)
    }
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
