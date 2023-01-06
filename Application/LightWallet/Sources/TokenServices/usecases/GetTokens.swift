import Combine
import Foundation
import Session

public protocol GetTokens {
  func invoke() -> AnyPublisher<[Token], Error>
  func get() -> AnyPublisher<[Token], Error>
}

public struct GetTokensImp: GetTokens {

  private let repository: TokenRepository
  private let sessionRepository: SessionRepository

  public init() {
    self.init(repository: TokenRepositoryImp(), sessionRepository: SessionRepositoryImp())
  }

  private init(repository: TokenRepository, sessionRepository: SessionRepository) {
    self.repository = repository
    self.sessionRepository = sessionRepository

  }

  public func invoke() -> AnyPublisher<[Token], Error> {
    repository.get().eraseToAnyPublisher()
  }

  public func get() -> AnyPublisher<[Token], Error> {
    guard let address = try? sessionRepository.getSelected().address.eip55Description else {
      return Fail(
        error: NSError(
          domain: "Missing session token",
          code: -10001,
          userInfo: nil)
      ).eraseToAnyPublisher()
    }
    return repository.get(with: address).eraseToAnyPublisher()
  }
}
