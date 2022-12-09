import Combine
import Foundation

public protocol EthereumClient {
  func performRequest<T: Decodable>(to query: Query) async throws -> T
}

public final class RPCEthereumClient: EthereumClient {
  public let networkProvider: EthereumNetworkProvider

  public convenience init() {
    self.init(networkProvider: RPCNetworkProvider())
  }

  private init(networkProvider: EthereumNetworkProvider) {
    self.networkProvider = networkProvider
  }

  public func performRequest<T: Decodable>(to query: Query) -> AnyPublisher<T, Error> {
    Empty().eraseToAnyPublisher()
  }

  public func performRequest<T: Decodable>(to query: Query) async throws -> T {
    try await networkProvider.performRequest(to: query)
  }
}
