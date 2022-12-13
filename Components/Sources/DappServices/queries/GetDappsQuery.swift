import Foundation
import Networking

public struct GetDappsQuery: Query {
  public var headers: [String: String]? {
    nil
  }

  public var method: HTTPMethod {
    .get
  }

  public var query: String {
    "/dapp.json"
  }

  public var body: Data? {
    return nil
  }

  public var service: Service {
    return .wallet
  }

  public init() {}
}
