import Foundation

// TransactionStruct since Transaction clashes with SwiftUI's native Transaction
// https://developer.apple.com/documentation/swiftui/transaction
public struct TransactionStruct: Hashable, Identifiable, Equatable {
  public let id: String
  public let name: String
  public let image: String
  public let quantity: String
  public let assetCode: String
  public let value: String

  public init(
    id: String, name: String, image: String, quantity: String, assetCode: String, value: String
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

  public static func == (lhs: TransactionStruct, rhs: TransactionStruct) -> Bool {
    return lhs.id == rhs.id
  }
}
