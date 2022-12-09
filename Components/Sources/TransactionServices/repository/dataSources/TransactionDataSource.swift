import Combine
import Commons
import Foundation
import Networking

public protocol TransactionDataSource {
  func fetch(from address: String) -> AnyPublisher<[Token], Error>
}

final class TransactionDataSourceImp: TransactionDataSource {

  private let socketClient: Client

  public convenience init() {
    self.init(
      socketClient: APIClient(with: .socket)
    )
  }

  init(socketClient: Client) {
    self.socketClient = socketClient
  }

  func fetch(from address: String) -> AnyPublisher<[Token], Error> {
    let query = GetTransactionsQuery(
      address: address
    )
    let request: AnyPublisher<[TokenDataModel], Error> = socketClient.performRequest(
      to: query)
    return request.map {
      $0.first!.payload.assets
        .filter { $0.value.asset.decimals != 0 }
        .map { $0.value.toDomain() }
        .sorted { $0.value > $1.value }
    }.eraseToAnyPublisher()
  }
}

extension TokenDataModel.DynamicAsset {
  func toDomain() -> Token {
    let quantity = (Double(self.quantity) ?? 0) / pow(10, 18)
    let value = self.asset.price?.value ?? 0
    let price = quantity * value
    return Token(
      id: UUID().uuidString,
      name: self.asset.name,
      image: self.asset.icon_url ?? "",
      quantity: String(format: "%.1f", quantity),
      assetCode: self.asset.symbol,
      value: price
    )
  }
}
