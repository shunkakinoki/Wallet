import Combine
import Foundation

public protocol GetDapps {
  func invoke() -> AnyPublisher<DappDataModel, Error>
  func retrieve(with address: String) -> AnyPublisher<DappDataModel, Error>
}

public struct GetDappsImp: GetDapps {

  private let repository: DappRepository

  public init() {
    self.init(repository: DappRepositoryImp())
  }

  private init(repository: DappRepository) {
    self.repository = repository
  }

  public func invoke() -> AnyPublisher<DappDataModel, Error> {
    repository.get().eraseToAnyPublisher()
  }

  public func retrieve(with address: String) -> AnyPublisher<DappDataModel, Error> {
    repository.get(with: address)
  }
}
