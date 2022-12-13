import Foundation

public struct Address: Hashable {
  public let id: String
  public let netWorth: Double

  public static let addressDefault = Address(
    id: "",
    netWorth: 0.0
  )
}
