import Combine
import Commons
import Foundation
import Session

public protocol AddressRepository {
  func get() -> AnyPublisher<Address, Error>
  func get(with address: String) -> AnyPublisher<Address, Error>
  func refresh() -> AnyPublisher<Address, Never>
}

public class AddressRepositoryImp: AddressRepository {
  private let dataSource: AddressDataSource
  private let session: SessionRepository
  private let address: Cache<Address>

  convenience public init() {
    self.init(
      dataSource: AddressDataSourceImp(),
      session: SessionRepositoryImp(),
      address: AddressServicesConfigure.address
    )
  }

  private init(
    dataSource: AddressDataSource, session: SessionRepository,
    address: Cache<Address>
  ) {
    self.dataSource = dataSource
    self.session = session
    self.address = address
  }

  public func get() -> AnyPublisher<Address, Error> {
    guard let address = try? session.getSelected().address else {
      return Empty().eraseToAnyPublisher()
    }
    return dataSource.fetch(from: address.eip55Description).eraseToAnyPublisher()
  }

  public func get(with address: String) -> AnyPublisher<Address, Error> {
    dataSource.fetch(from: address).eraseToAnyPublisher()
  }

  public func refresh() -> AnyPublisher<Address, Never> {
    guard let ethAddress = try? session.getSelected().address else {
      return Empty().eraseToAnyPublisher()
    }
    return dataSource.fetch(from: ethAddress.eip55Description)
      .handleEvents(receiveOutput: address.set)
      .catch { _ in Empty<Address, Never>() }
      .eraseToAnyPublisher()
  }
}
