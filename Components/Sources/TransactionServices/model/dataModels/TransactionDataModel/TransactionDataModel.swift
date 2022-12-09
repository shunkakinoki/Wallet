import Foundation

struct TransactionDataModel: Decodable {

  public let meta: Meta
  public let payload: Payload

  struct Meta: Codable {
    let status: String
    let address: String?
    let addresses: [String]
    let currency: String
  }

  public struct Payload: Decodable {
    public let assets: [String: DynamicAsset]
  }

  public struct DynamicAsset: Decodable {
    public let asset: Asset
    public let quantity: String
  }

  public struct Asset: Decodable {
    public let name: String
    public let symbol: String
    public let asset_code: String
    public let icon_url: String?
    public let decimals: Int
    public let price: Price?
  }

  public struct Price: Decodable {
    public let value: Double?
  }
}
