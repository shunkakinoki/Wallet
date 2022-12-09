import Combine
import Commons
import Foundation
import Session

public protocol TransactionRepository {
  func get() -> AnyPublisher<[Token], Error>
  func get(with address: String) -> AnyPublisher<[Token], Error>
  func refresh() -> AnyPublisher<[Token], Never>
}

public class TransactionRepositoryImp: TransactionRepository {

  private let dataSource: TransactionDataSource
  private let session: SessionRepository
  private let tokens: ArrayCache<Token>

  convenience public init() {
    self.init(
      dataSource: TransactionDataSourceImp(),
      session: SessionRepositoryImp(),
      tokens: TransactionServicesConfigure.tokens
    )
  }

  private init(
    dataSource: TransactionDataSource, session: SessionRepository, tokens: ArrayCache<Token>
  ) {
    self.dataSource = dataSource
    self.session = session
    self.tokens = tokens
  }

  public func get() -> AnyPublisher<[Token], Error> {
    guard let address = try? session.getSelected().address else {
      return Empty().eraseToAnyPublisher()
    }
    return dataSource.fetch(from: address.eip55Description).eraseToAnyPublisher()
  }

  public func get(with address: String) -> AnyPublisher<[Token], Error> {
    dataSource.fetch(from: address).eraseToAnyPublisher()
  }

  public func refresh() -> AnyPublisher<[Token], Never> {
    guard let address = try? session.getSelected().address else {
      return Empty().eraseToAnyPublisher()
    }
    return dataSource.fetch(from: address.eip55Description)
      .handleEvents(receiveOutput: tokens.set)
      .catch { _ in Empty<[Token], Never>() }
      .eraseToAnyPublisher()
  }
}
