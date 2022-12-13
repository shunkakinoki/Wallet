public enum Service {
  case coherent
  case alchemy
  case zerion
}

extension Service {
  var baseUrl: String {
    switch self {
    case .coherent:
      return "https://wallet.light.so/api/coherent"
    case .alchemy:
      return "https://eth-goerli.g.alchemy.com/v2/OIt7MkMnQhtqZsnFLOU2hOEJ8imiJd-X"
    case .wallet:
      return "https://wallet.light.so"
    case .zerion:
      return "wss://api-v4.zerion.io/socket.io"
    }
  }
}
