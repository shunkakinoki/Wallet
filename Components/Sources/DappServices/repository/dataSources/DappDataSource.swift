import Combine
import Commons
import Foundation
import Networking

public protocol DappDataSource {
  func fetch(from address: String) -> AnyPublisher<[Dapp], Error>
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

  func fetch(from address: String) -> AnyPublisher<[Dapp], Error> {
    let query = GetDappsQuery()
    let request: AnyPublisher<DappDataModel, Error> = restClient.performRequest(
      to: query)
    return
      request
      .map { $0.dapps.map { $0.toModel() } }
      .eraseToAnyPublisher()
  }
}

extension DappDataModel.Dapp {
  func toModel() -> Dapp {
    return Dapp(
      name: self.name,
      icon: self.icon,
      site: self.site,
      type: self.type
    )
  }
}
