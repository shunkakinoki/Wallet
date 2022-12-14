import Combine
import DappServices
import Domain
import Foundation
import Session
import SwiftUI
import UIKit

public final class ExploreViewModel: ObservableObject {

  private let getHostConfiguration: GetHostConfiguration
  private let getDapps: GetDapps

  private var subscriptions = Set<AnyCancellable>()

  @Published
  var configurations = [Dapp]()

  @Published
  var dapps = [Dapp]()

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
  }

  public func getConfiguration() {
    if let config = getHostConfiguration.get() {
      self.configurations = config.map { $0.toModel() }
    }
  }

  @MainActor
  public func getDapps() async {
    getDapps.get()
      .receive(on: DispatchQueue.main)
      .sink(
        receiveCompletion: { error in
          print(error)
          self.isLoading = false
          self.isValidating = false
        },
        receiveValue: { value in
          self.dapps = value
        }
      )
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

extension HostConfigurationModel.HostConfigurationParameters {
  func toModel() -> Dapp {
    return Dapp(
      name: self.host,
      icon: "https://\(self.host)/\(self.favicon ?? "favicon.ico")",
      site: "https://\(self.host)",
      type: "host"
    )
  }
}
