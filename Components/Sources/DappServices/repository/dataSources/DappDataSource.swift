import Combine
import Commons
import Foundation
import Networking

public protocol DappDataSource {
  func fetch() -> AnyPublisher<DappDataModel, Error>
}

final class DappDataSourceImp: DappDataSource {

  private let restClient: Client

  public convenience init() {
    self.init(
      restClient: APIClient(with: .rest)
    )
  }

  init(restClient: Client) {
    self.restClient = restClient
  }

  func fetch() -> AnyPublisher<DappDataModel, Error> {
    let query = GetDappsQuery()
    let request: AnyPublisher<DappDataModel, Error> = restClient.performRequest(
      to: query)
    return
      request
      .eraseToAnyPublisher()
  }
}
