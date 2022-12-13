import Foundation

struct AddressDataModel: Decodable {
  public let address: String
  public let blockchains: [String]
  public let domainName: String
  public let type: String
  public let netWorth: NetWorth

  public struct NetWorth: Decodable {
    public let amount: Double
    public let currency: String
  }
}
