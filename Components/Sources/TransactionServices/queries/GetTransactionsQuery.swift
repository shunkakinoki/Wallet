import Foundation
import Networking

public struct GetTransactionsQuery: Query {
  public var headers: [String: String]? {
    nil
  }

  public var method: HTTPMethod {
    .get
  }

  public var query: String {
    "\(address)"
  }

  public var body: Data? {
    return nil
  }

  public var service: Service {
    return .zerion
  }

  private let address: String

  public init(address: String) {
    self.address = address
  }
}
