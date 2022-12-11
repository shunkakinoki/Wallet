import Foundation
import Networking

struct GetTokensQuery: Query {
  var headers: [String: String]? {
    [
      "Accept": "application/json",
      "Content-Type": "application/json",
    ]
  }

  var method: HTTPMethod {
    .post
  }

  var query: String {
    "\(address)"
  }

  var body: Data? {
    return nil
  }

  var service: Service {
    return .zerion
  }

  private let address: String

  init(address: String) {
    self.address = address
  }
}
