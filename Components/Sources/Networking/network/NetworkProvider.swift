import Combine
import Foundation

public protocol NetworkProvider {
  func performRequest<T: Decodable>(to query: Query) async throws -> T
}

public protocol WsNetworkProvider {
  func performRequest(to query: Query) async throws -> Data
}
