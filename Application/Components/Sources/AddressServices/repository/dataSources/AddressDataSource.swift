import Combine
import Commons
import Foundation
import Networking

public protocol AddressDataSource {
  func fetch(from address: String) -> AnyPublisher<Address, Error>
}

final class AddressDataSourceImp: AddressDataSource {

  private let restClient: Client

  public convenience init() {
    self.init(
      restClient: APIClient(with: .rest)
    )
  }

  init(restClient: Client) {
    self.restClient = restClient
  }

  func fetch(from address: String) -> AnyPublisher<Address, Error> {
    let query = GetAddressQuery(
      address: address
    )
    let request: AnyPublisher<AddressDataModel, Error> = restClient.performRequest(
      to: query)
    return
      request
      .map { $0.toDomain() }
      .eraseToAnyPublisher()
  }
}

extension AddressDataModel {
  func toDomain() -> Address {
    return Address(
      id: self.address,
      netWorth: self.netWorth.amount ?? 0.0
    )
  }
}
