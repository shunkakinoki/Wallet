import Combine
import Commons
import Foundation
import Session

public protocol DappRepository {
  func get() -> AnyPublisher<[Dapp], Error>
  func get(with dapp: String) -> AnyPublisher<[Dapp], Error>
  func refresh() -> AnyPublisher<[Dapp], Never>
}

public class DappRepositoryImp: DappRepository {
  private let dataSource: DappDataSource
  private let session: SessionRepository
  private let dapps: ArrayCache<Dapp>

  convenience public init() {
    self.init(
      dataSource: DappDataSourceImp(),
      session: SessionRepositoryImp(),
      dapps: DappServicesConfigure.dapps
    )
  }

  private init(
    dataSource: DappDataSource, session: SessionRepository,
    dapps: ArrayCache<Dapp>
  ) {
    self.dataSource = dataSource
    self.session = session
    self.dapps = dapps
  }

  public func get() -> AnyPublisher<[Dapp], Error> {
    guard let address = try? session.getSelected().address else {
      return Empty().eraseToAnyPublisher()
    }
    return dataSource.fetch(from: address.eip55Description).eraseToAnyPublisher()
  }

  public func get(with dapp: String) -> AnyPublisher<[Dapp], Error> {
    dataSource.fetch(from: dapp).eraseToAnyPublisher()
  }

  public func refresh() -> AnyPublisher<[Dapp], Never> {
    guard let address = try? session.getSelected().address else {
      return Empty().eraseToAnyPublisher()
    }
    return dataSource.fetch(from: address.eip55Description)
      .handleEvents(receiveOutput: dapps.set)
      .catch { _ in Empty<[Dapp], Never>() }
      .eraseToAnyPublisher()
  }
}
