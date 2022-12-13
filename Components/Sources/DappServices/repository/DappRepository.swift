import Combine
import Commons
import Foundation

public protocol DappRepository {
  func get() -> AnyPublisher<DappDataModel, Error>
  func get(with address: String) -> AnyPublisher<DappDataModel, Error>
  func refresh() -> AnyPublisher<DappDataModel, Never>
}

public class DappRepositoryImp: DappRepository {

  private let dataSource: DappDataSource
  private let session: SessionRepository
  private let dapps: Cache<DappDataModel>

  convenience public init() {
    self.init(
      dataSource: DappDataSourceImp(),
      session: SessionRepositoryImp(),
      dapps: DappServicesConfigure.dapps
    )
  }

  private init(
    dataSource: DappDataSource, session: SessionRepository,
    dapps: Cache<DappDataModel>
  ) {
    self.dataSource = dataSource
    self.session = session
    self.dapps = dapps
  }

  public func get() -> AnyPublisher<DappDataModel, Error> {
    return dataSource.fetch().eraseToAnyPublisher()
  }

  public func get(with address: String) -> AnyPublisher<DappDataModel, Error> {
    dataSource.fetch(from: address).eraseToAnyPublisher()
  }

  public func refresh() -> AnyPublisher<DappDataModel, Never> {
    return dataSource.fetch()
      .handleEvents(receiveOutput: dapps.set)
      .catch { _ in Empty<DappDataModel, Never>() }
      .eraseToAnyPublisher()
  }
}
