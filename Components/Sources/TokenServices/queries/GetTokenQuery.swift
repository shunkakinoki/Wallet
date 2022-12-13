import Foundation
import Networking

public struct GetTokenQuery: Query {
  public var headers: [String: String]? {
    nil
  }

  public var method: HTTPMethod {
    .get
  }

  public var query: String {
    "/v1/address/\(address)"
  }

  public var body: Data? {
    return nil
  }

  public var service: Service {
    return .coherent
  }

  private let address: String

  public init(address: String) {
    self.address = address
  }
}
