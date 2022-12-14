import Foundation

struct DappDataModel: Decodable {
  public let dapps: [Dapp]

  public struct Dapp: Decodable {
    public let site: String
    public let icon: String
    public let name: String
    public let type: String
  }
}
