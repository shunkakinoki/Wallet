import Foundation
import Combine

public extension Publisher where Output == Data {
    func decode<T: Decodable>(
        as type: T.Type = T.self,
        using decoder: JSONDecoder = .init()
    ) -> Publishers.Decode<Self, T, JSONDecoder> {
        decode(type: type, decoder: decoder)
    }
}
