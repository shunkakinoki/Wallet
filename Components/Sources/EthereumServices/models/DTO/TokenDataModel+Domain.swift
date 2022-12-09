import Foundation

extension TokenDataModel.DynamicAsset {
  func toDomain() -> Token {
    let quantity = (Double(self.quantity) ?? 0) / pow(10, 18)
    let value = self.asset.price?.value ?? 0
    let price = quantity * value
    return Token(
      id: UUID().uuidString,
      name: self.asset.name,
      image: self.asset.icon_url ?? "",
      quantity: quantity.toString(),
      assetCode: self.asset.symbol,
      value: price
    )
  }
}
