import Combine
import Foundation

public protocol GetTransactions {
  func invoke() -> AnyPublisher<[Token], Error>
  func retrieve(with address: String) -> AnyPublisher<[Token], Error>
}

public struct GetTransactionsImp: GetTransactions {

  private let repository: TransactionRepository

  public init() {
    self.init(repository: TransactionRepositoryImp())
  }

  private init(repository: TransactionRepository) {
    self.repository = repository
  }

  public func invoke() -> AnyPublisher<[Token], Error> {
    repository.get().eraseToAnyPublisher()
  }

  public func retrieve(with address: String) -> AnyPublisher<[Token], Error> {
    repository.get(with: address)
  }
}
