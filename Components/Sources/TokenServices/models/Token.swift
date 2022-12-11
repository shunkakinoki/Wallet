import Foundation

public struct Token: Hashable, Identifiable, Equatable {
  public let id: String
  public let name: String
  public let image: String
  public let quantity: String
  public let assetCode: String
  public let value: Double

  public init(
    id: String, name: String, image: String, quantity: String, assetCode: String, value: Double
  ) {
    self.id = id
    self.name = name
    self.image = image
    self.quantity = quantity
    self.assetCode = assetCode
    self.value = value
  }

  public func hash(into hasher: inout Hasher) {
    hasher.combine(id)
  }

  public static func == (lhs: Token, rhs: Token) -> Bool {
    return lhs.id == rhs.id
  }
}
