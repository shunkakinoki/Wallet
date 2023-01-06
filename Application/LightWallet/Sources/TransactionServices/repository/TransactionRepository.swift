import Combine
import Commons
import Foundation
import Session

public protocol TransactionRepository {
  func get() -> AnyPublisher<[TransactionStruct], Error>
  func get(with address: String) -> AnyPublisher<[TransactionStruct], Error>
  func refresh() -> AnyPublisher<[TransactionStruct], Never>
}

public class TransactionRepositoryImp: TransactionRepository {

  private let dataSource: TransactionDataSource
  private let session: SessionRepository
  private let transactionstructs: ArrayCache<TransactionStruct>

  convenience public init() {
    self.init(
      dataSource: TransactionDataSourceImp(),
      session: SessionRepositoryImp(),
      transactionstructs: TransactionServicesConfigure.transactionstructs
    )
  }

  private init(
    dataSource: TransactionDataSource, session: SessionRepository,
    transactionstructs: ArrayCache<TransactionStruct>
  ) {
    self.dataSource = dataSource
    self.session = session
    self.transactionstructs = transactionstructs
  }

  public func get() -> AnyPublisher<[TransactionStruct], Error> {
    guard let address = try? session.getSelected().address else {
      return Empty().eraseToAnyPublisher()
    }
    return dataSource.fetch(from: address.eip55Description).eraseToAnyPublisher()
  }

  public func get(with address: String) -> AnyPublisher<[TransactionStruct], Error> {
    dataSource.fetch(from: address).eraseToAnyPublisher()
  }

  public func refresh() -> AnyPublisher<[TransactionStruct], Never> {
    guard let address = try? session.getSelected().address else {
      return Empty().eraseToAnyPublisher()
    }
    return dataSource.fetch(from: address.eip55Description)
      .handleEvents(receiveOutput: transactionstructs.set)
      .catch { _ in Empty<[TransactionStruct], Never>() }
      .eraseToAnyPublisher()
  }
}
