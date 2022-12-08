import Foundation
import Networking

struct GetEstimatedGasQuery: Query {
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
    "eth_estimateGas"
  }

  var body: Data? {
    return [
      "jsonrpc": "2.0",
      "method": self.query,
      "params": [
        "from": self.from,
        "to": self.to,
        "data": self.value,
      ],
      "id": 0,
    ].toData()
  }

  var service: Service {
    return .alchemy
  }

  private let to: String
  private let from: String
  private let value: String

  init(to: String, from: String, value: String) {
    self.to = to
    self.from = from
    self.value = value
  }
}
