import Foundation
import Networking

struct GetTransactionCountQuery: Query {
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
    "eth_getTransactionCount"
  }

  var body: Data? {
    return [
      "jsonrpc": "2.0",
      "method": self.query,
      "params": [
        address,
        "latest",
      ],
      "id": 1,
    ].toData()
  }

  var service: EthereumService {
    return .alchemy
  }

  private let address: String

  init(address: String) {
    self.address = address
  }
}
