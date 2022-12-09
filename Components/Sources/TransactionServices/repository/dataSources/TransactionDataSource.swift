import Combine
import Commons
import Foundation
import Networking

public protocol TransactionDataSource {
  func fetch(from address: String) -> AnyPublisher<[TransactionStruct], Error>
}

final class TransactionDataSourceImp: TransactionDataSource {

  private let restClient: Client

  public convenience init() {
    self.init(
      restClient: APIClient(with: .rest)
    )
  }

  init(restClient: Client) {
    self.restClient = restClient
  }

  func fetch(from address: String) -> AnyPublisher<[TransactionStruct], Error> {
    let query = GetTransactionsQuery(
      address: address
    )
    let request: AnyPublisher<[TransactionDataModel], Error> = restClient.performRequest(
      to: query)
    return request.map {
      $0.first!.transactions
        .map { $0.toDomain() }
    }.eraseToAnyPublisher()

  }
}

extension TransactionDataModel.Transaction {
  func toDomain() -> TransactionStruct {
    return TransactionStruct(
      id: self.txHash,
      name: self.action.verb?.hashValue,
      image: "",
      quantity: String(format: "%.1f", 0),
      assetCode: self.action.object.rawValue,
      value: 1.0
    )
  }

}
