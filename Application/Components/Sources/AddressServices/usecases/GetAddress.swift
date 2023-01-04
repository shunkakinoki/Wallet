import Combine
import Foundation
import Session

public protocol GetAddress {
  func invoke() -> AnyPublisher<Address, Error>
  func get() -> AnyPublisher<Address, Error>
}

public struct GetAddressImp: GetAddress {

  private let repository: AddressRepository
  private let sessionRepository: SessionRepository

  public init() {
    self.init(repository: AddressRepositoryImp(), sessionRepository: SessionRepositoryImp())
  }

  private init(repository: AddressRepository, sessionRepository: SessionRepository) {
    self.repository = repository
    self.sessionRepository = sessionRepository

  }

  public func invoke() -> AnyPublisher<Address, Error> {
    repository.get().eraseToAnyPublisher()
  }

  public func get() -> AnyPublisher<Address, Error> {
    guard let address = try? sessionRepository.getSelected().address.eip55Description else {
      return Fail(
        error: NSError(
          domain: "Missing session address",
          code: -10001,
          userInfo: nil)
      ).eraseToAnyPublisher()
    }
    return repository.get(with: address).eraseToAnyPublisher()
  }
}
