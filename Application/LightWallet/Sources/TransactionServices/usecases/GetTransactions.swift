import Combine
import Foundation

public protocol GetTransactions {
  func invoke() -> AnyPublisher<[TransactionStruct], Error>
  func retrieve(with address: String) -> AnyPublisher<[TransactionStruct], Error>
}

public struct GetTransactionsImp: GetTransactions {

  private let repository: TransactionRepository

  public init() {
    self.init(repository: TransactionRepositoryImp())
  }

  private init(repository: TransactionRepository) {
    self.repository = repository
  }

  public func invoke() -> AnyPublisher<[TransactionStruct], Error> {
    repository.get().eraseToAnyPublisher()
  }

  public func retrieve(with address: String) -> AnyPublisher<[TransactionStruct], Error> {
    repository.get(with: address)
  }
}
