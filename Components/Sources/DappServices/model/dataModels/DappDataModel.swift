import Foundation

public struct DappDataModel: Decodable {
  public let dapps: Dapps

  public struct Dapps: Decodable {
    public let bridge: [Dapp]
    public let mint: [Dapp]
    public let nft: [Dapp]
    public let swap: [Dapp]

    public init() {
      self.bridge = []
      self.nft = []
      self.mint = []
      self.swap = []
    }
  }

  public struct Dapp: Decodable {
    public let name: String
    public let icon: String
    public let site: String
  }

  public init() {
    self.dapps = Dapps()
  }
}
