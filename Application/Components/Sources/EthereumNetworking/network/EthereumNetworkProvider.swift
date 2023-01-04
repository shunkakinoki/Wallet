import Combine
import Foundation

public protocol EthereumNetworkProvider {
  func performRequest<T: Decodable>(to query: Query) async throws -> T
}
