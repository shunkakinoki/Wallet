import Combine
import Commons
import Foundation

public protocol DappRepository {
  func get() -> AnyPublisher<DappDataModel, Error>
  func refresh() -> AnyPublisher<DappDataModel, Never>
}

public class DappRepositoryImp: DappRepository {

  private let dataSource: DappDataSource
  private let dapps: Cache<DappDataModel>

  convenience public init() {
    self.init(
      dataSource: DappDataSourceImp(),
      dapps: DappServicesConfigure.dapps
    )
  }

  private init(
    dataSource: DappDataSource,
    dapps: Cache<DappDataModel>
  ) {
    self.dataSource = dataSource
    self.dapps = dapps
  }

  public func get() -> AnyPublisher<DappDataModel, Error> {
    return dataSource.fetch().eraseToAnyPublisher()
  }

  public func refresh() -> AnyPublisher<DappDataModel, Never> {
    return dataSource.fetch()
      .handleEvents(receiveOutput: dapps.set)
      .catch { _ in Empty<DappDataModel, Never>() }
      .eraseToAnyPublisher()
  }
}
