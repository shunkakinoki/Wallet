import Foundation
import Combine

public protocol NetworkProvider {
    func performRequest<T: Decodable>(to query: Query) async throws -> T
}
