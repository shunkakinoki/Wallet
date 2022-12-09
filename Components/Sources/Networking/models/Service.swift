public enum EthereumService {
  case alchemy
}

extension EthereumService {
  var baseUrl: String {
    switch self {
    case .alchemy:
      return "https://eth-goerli.g.alchemy.com/v2/OIt7MkMnQhtqZsnFLOU2hOEJ8imiJd-X"
    }
  }
}
