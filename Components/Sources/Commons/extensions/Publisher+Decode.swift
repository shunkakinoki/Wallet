import Combine
import Foundation

extension Publisher where Output == Data {
  public func decode<T: Decodable>(
    as type: T.Type = T.self,
    using decoder: JSONDecoder = .init()
  ) -> Publishers.Decode<Self, T, JSONDecoder> {
    decode(type: type, decoder: decoder)
  }
}
