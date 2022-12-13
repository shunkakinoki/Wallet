import Combine
import Foundation

public protocol Client {
  func performRequest<T: Decodable>(to query: Query) -> AnyPublisher<T, Error>
}

public final class APIClient: Client {
  public let networkProvider: NetworkProvider

  public convenience init(with layer: Layer) {
    switch layer {
    case .rest:
      self.init(networkProvider: RestAPINetworkProvider())
    case .graphql:
      self.init(networkProvider: GraphQLNetworkProvider())
    }
  }

  private init(networkProvider: NetworkProvider) {
    self.networkProvider = networkProvider
  }

  public func performRequest<T: Decodable>(to query: Query) -> AnyPublisher<T, Error> {
    networkProvider.performRequest(to: query)
  }
}
