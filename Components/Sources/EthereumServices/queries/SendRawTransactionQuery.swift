import EthereumNetworking
import Foundation

struct SendRawTransactionQuery: Query {
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
    "eth_sendRawTransaction"
  }

  var body: Data? {
    return [
      "jsonrpc": "2.0",
      "method": self.query,
      "params": [
        signature
      ],
      "id": 1,
    ].toData()
  }

  var service: EthereumService {
    return .alchemy
  }

  private let signature: String

  init(signature: String) {
    self.signature = signature
  }
}
