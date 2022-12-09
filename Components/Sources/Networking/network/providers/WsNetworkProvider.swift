import Combine
import Foundation
import SocketIO
import Commons

public final class WsNetworkProvider: NetworkProvider {

  private let networkSession: URLSession
  private var cancellables: Set<AnyCancellable> = []

  public convenience init() {
    self.init(networkSession: .shared)
  }

  private let socketManager: SocketManager
  private let socketClient: SocketIOClient

  public init(networkSession: URLSession) {
    self.networkSession = networkSession
    self.socketManager = SocketManager(
      socketURL: URL(string: "wss://api-v4.zerion.io")!,
      config: [
        .log(false),
        .forceWebsockets(true),
        .connectParams( ["api_token": ""]),
        .version(.two),
        .secure(true)
      ]
    )
    self.socketClient = self.socketManager.socket(forNamespace: "/address")
    self.socketClient.connect()
  }

  enum APIError: Error {
      case wrongQuery
  }

  public func performRequest<T>(
      to query: Query
  ) async throws -> T where T : Decodable {
    try await ping(query.query)
      .decode(as: T.self)
      .first()
      .eraseToAnyPublisher()
      .async()
  }

  private func ping(_ address: String) -> Future<Data, Never> {
    Future { [weak self] promise in
      guard let self = self else { return }
      self.socketClient.on(clientEvent: .connect) { [self] data, ack in
        self.socketClient.emit(
          "subscribe", ["scope": ["assets"], "payload": ["address": address, "currency": "usd"]]
        )
        self.socketClient.on("received address assets") { data, ack in
          let jsonData = try? JSONSerialization.data(withJSONObject: data)
          promise(.success(jsonData!))
          self.socketClient.disconnect()
        }
      }
    }
  }
}
