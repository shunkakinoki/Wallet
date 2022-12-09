import Combine
import Foundation
import SocketIO

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
        .extraHeaders(["Origin": "https://light.so"]),
        .forceWebsockets(true),
        .connectParams(["api_token": "Light.naTLgmR7DH1LLlZZXWLtqh6xRZ7D6wa6"]),
        .version(.two),
        .secure(true),
      ]
    )
    self.socketClient = socketManager.socket(forNamespace: "/address")
    self.socketClient.connect()
  }

  public func performRequest<T>(to query: Query) -> AnyPublisher<T, Error> where T: Decodable {
    ping(query.query)
      .decode(as: T.self)
      .first()
      .eraseToAnyPublisher()
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
