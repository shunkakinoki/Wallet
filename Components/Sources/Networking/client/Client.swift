import Combine
import Foundation

public protocol Client {
  func performRequest<T: Decodable>(to query: Query) async throws -> T
}

public final class APIClient: Client {
  public let networkProvider: NetworkProvider

  public convenience init(with layer: Layer) {
    switch layer {
    case .rest:
      self.init(networkProvider: RestAPINetowkrProvider())
    case .rpc:
      self.init(networkProvider: RPCNetworkProvider())
    }
  }

  private init(networkProvider: NetworkProvider) {
    self.networkProvider = networkProvider
  }

  public func performRequest<T: Decodable>(to query: Query) -> AnyPublisher<T, Error> {
    Empty().eraseToAnyPublisher()
  }

  public func performRequest<T: Decodable>(to query: Query) async throws -> T {
    try await networkProvider.performRequest(to: query)
  }
}
