public enum Service {
  case coherent
  case zerion
}

extension Service {
  var baseUrl: String {
    switch self {
    case .coherent:
      return "https://wallet.light.so/api/coherent"
    case .zerion:
      return "wss://api-v4.zerion.io/socket.io"
    }
  }
}
