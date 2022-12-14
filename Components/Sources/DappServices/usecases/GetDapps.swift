import Combine
import Foundation
import Session

public protocol GetDapps {
  func invoke() -> AnyPublisher<[Dapp], Error>
  func get() -> AnyPublisher<[Dapp], Error>
}

public struct GetDappsImp: GetDapps {

  private let repository: DappRepository

  public init() {
    self.init(repository: DappRepositoryImp())
  }

  private init(repository: DappRepository) {
    self.repository = repository
  }

  public func invoke() -> AnyPublisher<[Dapp], Error> {
    repository.get().eraseToAnyPublisher()
  }

  public func get() -> AnyPublisher<[Dapp], Error> {
    return repository.get().eraseToAnyPublisher()
  }
}
