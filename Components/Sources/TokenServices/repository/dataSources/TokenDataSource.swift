import Combine
import Commons
import Foundation
import Networking

public protocol TokenDataSource {
  func fetch(from address: String) -> AnyPublisher<[Token], Error>
}

final class TokenDataSourceImp: TokenDataSource {

  private let restClient: Client

  public convenience init() {
    self.init(
      restClient: APIClient(with: .rest)
    )
  }

  init(restClient: Client) {
    self.restClient = restClient
  }

  func fetch(from address: String) -> AnyPublisher<[Token], Error> {
    let query = GetTokenQuery(
      address: address
    )
    let request: AnyPublisher<[TokenDataModel], Error> = restClient.performRequest(
      to: query)
    return
      request
      .map { $0.map { $0.toModel() } }
      .eraseToAnyPublisher()
  }
}

extension TokenDataModel {
  func toModel() -> Token {
    return Token(
      id: self.asset.address,
      name: self.asset.name,
      symbol: self.asset.symbol,
      amount: self.amount ?? 0.0,
      value: self.nativeValue.amount
    )
  }
}
