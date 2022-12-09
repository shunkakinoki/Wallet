import Combine
import Foundation

public protocol GetTokens {
  func invoke() -> AnyPublisher<[Token], Error>
  func retrieve(with address: String) -> AnyPublisher<[Token], Error>
}

public struct GetTokensImp: GetTokens {

  private let repository: TokenRepository

  public init() {
    self.init(repository: TokenRepositoryImp())
  }

  private init(repository: TokenRepository) {
    self.repository = repository
  }

  public func invoke() -> AnyPublisher<[Token], Error> {
    repository.get().eraseToAnyPublisher()
  }

  public func retrieve(with address: String) -> AnyPublisher<[Token], Error> {
    repository.get(with: address)
  }
}
