import Foundation

public protocol Query {
    var query: String { get }
    var method: HTTPMethod { get }
    var service: Service { get }
    var body: Data? { get }
    var headers: [String: String]? { get }
}
