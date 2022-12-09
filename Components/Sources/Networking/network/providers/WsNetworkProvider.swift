import Combine
import Foundation
import SocketIO
import Commons

public final class WsNetworkProviderImp: WsNetworkProvider {

  private let networkSession: URLSession
  private var cancellables: Set<AnyCancellable> = []

  public convenience init() {
    self.init(networkSession: .shared)
  }

  private let socketManager: SocketManager
  private let socketClient: SocketIOClient
  private let timeout: Double = 10
  private var connectContinuation: CheckedContinuation<(), Error>?
  private var assetsContinuation: CheckedContinuation<Data, Error>?

  public init(networkSession: URLSession) {
    self.networkSession = networkSession
    self.socketManager = SocketManager(
      socketURL: URL(string: "wss://api-v4.zerion.io")!,
      config: [
        .log(false),
        .forceWebsockets(true),
        .connectParams( ["api_token": ProcessInfo.processInfo.environment["NEXT_PUBLIC_ZERION_API_KEY"] ?? ""]),
        .version(.two),
        .secure(true)
      ]
    )
    self.socketClient = socketManager.socket(forNamespace: "/address")
    self.listenForConnections()
    self.listenForAssets()
  }

  private func listenForConnections() {
    socketClient.on(clientEvent: .connect) { [weak self] data, ack in
      self?.connectContinuation?.resume(with: .success(()))
      self?.connectContinuation = nil
    }
  }

  private func listenForAssets() {
    socketClient.on("received address assets") { data, ack in
      do {
        let data = try JSONSerialization.data(withJSONObject: data, options: .fragmentsAllowed)
        self.assetsContinuation?.resume(with: .success(data))
      } catch let error {
        self.assetsContinuation?.resume(with: .failure(error))
      }
    }
  }

  public func performRequest(to query: Query) async throws -> Data {
    try await connectIfNeeded()
    self.socketClient.emit(
      "subscribe", ["scope": ["assets"], "payload": ["address": query.query, "currency": "usd"]]
    )
    return try await withCheckedThrowingContinuation { [weak self] continuation in
        self?.assetsContinuation = continuation
    }
  }

  private func connectIfNeeded() async throws {
    return try await withCheckedThrowingContinuation { [weak self] continuation in
      guard socketClient.status != .connected else {
        continuation.resume(with: .success(()))
        return
      }
      self?.connectContinuation = continuation
      socketClient.connect(timeoutAfter: timeout) {
        continuation.resume(with: .failure(NSError(domain: "ws connection", code: 1)))
        self?.connectContinuation = nil
        return
      }
    }
  }
}
