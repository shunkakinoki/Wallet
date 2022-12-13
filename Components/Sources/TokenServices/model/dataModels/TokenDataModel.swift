import Foundation

struct TokenDataModel: Decodable {
  public let amount: Double
  public let type: String
  public let nativeValue: NativeValue
  public let asset: Asset
  public let blockchain: String

  public struct NativeValue: Decodable {
    public let amount: Double
    public let currency: String
  }

  public struct Asset: Decodable {
    public let address: String
    public let name: String
    public let symbol: String
    public let standard: String
    public let decimals: Int
  }
}
