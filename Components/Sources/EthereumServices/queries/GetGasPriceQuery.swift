import Foundation
import Networking

struct GetGasPriceQuery: Query {
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
    "eth_gasPrice"
  }

  var body: Data? {
    return [
      "jsonrpc": "2.0",
      "method": self.query,
      "id": 1,
    ].toData()
  }

  var service: Service {
    return .alchemy
  }
}
