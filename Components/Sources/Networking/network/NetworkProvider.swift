import Combine
import Foundation

public protocol NetworkProvider {
  func performRequest<T: Decodable>(to query: Query) -> AnyPublisher<T, Error>
}
