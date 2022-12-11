import Combine
import Domain
import Foundation
import Session

public protocol GetTokens {
  func get() async throws -> [Token]
}

public class GetTokensImp: GetTokens {

  private let repository: TokenRepository
  private let sessionRepository: SessionRepository

  convenience public init() {
    self.init(repository: TokenRepositoryImp(), sessionRepository: SessionRepositoryImp())
  }

  private init(repository: TokenRepository, sessionRepository: SessionRepository) {
    self.repository = repository
    self.sessionRepository = sessionRepository
  }

  public func get() async throws -> [Token] {
    let address = try sessionRepository.getSelected().address.eip55Description
    return try await repository.fetch(with: address)
  }
}
