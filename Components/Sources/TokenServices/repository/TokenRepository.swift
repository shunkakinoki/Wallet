import Combine
import Domain
import Foundation

public protocol TokenRepository {
  func fetch(with address: String) async throws -> [Token]
}

public class TokenRepositoryImp: TokenRepository {

  private let dataSource: TokensDataSource

  convenience public init() {
    self.init(dataSource: TokensDataSourceImp())
  }

  private init(dataSource: TokensDataSource) {
    self.dataSource = dataSource
  }

  public func fetch(with address: String) async throws -> [Token] {
    try await dataSource.getTokens(from: address)
  }
}
