import Foundation

public struct Token: Hashable {
  public let id: String
  public let blockchain: String
  public let name: String
  public let symbol: String
  public let amount: Double
  public let value: Double

  public static let tokenDefault = Token(
    id: "",
    blockchain: "ethereum",
    name: "",
    symbol: "",
    amount: 0.0,
    value: 0.0
  )
}
