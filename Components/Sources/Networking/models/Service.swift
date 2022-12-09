public enum Service {
  case zerion
}

extension Service {
  var baseUrl: String {
    switch self {
    case .zerion:
      return "wss://api-v4.zerion.io/socket.io"
    }
  }
}
