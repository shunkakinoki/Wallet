import Foundation

public enum EthereumWalletType: Codable {
  case privateKey
  case mnemonic
  case derivedWallet
}

public enum EthereumWalletColor: String, Codable, CaseIterable {
  case green
  case indigo
  case orange
  case pink
  case purple
  case red
  case teal
  case yellow
}

public final class EthereumWallet: Identifiable {

  public let id = UUID()
  public let address: EthereumAddress
  public let cipherText: Data
  public let type: EthereumWalletType
  public let timestamp: Date
  public let color: EthereumWalletColor
  public let name: String

  public init(
    address: EthereumAddress, cipherText: Data, type: EthereumWalletType, timestamp: Date,
    color: EthereumWalletColor, name: String
  ) {
    self.address = address
    self.cipherText = cipherText
    self.type = type
    self.timestamp = timestamp
    self.color = color
    self.name = name
  }
}

extension EthereumWallet: Hashable {
  public func hash(into hasher: inout Hasher) {
    hasher.combine(address.eip55Description)
  }
}

extension EthereumWallet: Comparable {
  public static func < (lhs: EthereumWallet, rhs: EthereumWallet) -> Bool {
    lhs.timestamp < rhs.timestamp
  }
}

extension EthereumWallet: Encodable {

  private enum Keys: String, CodingKey {
    case address = "address"
    case color = "color"
    case name = "name"
  }

  public func encode(to encoder: Encoder) throws {
    var container = encoder.container(keyedBy: Keys.self)
    try container.encode(address.eip55Description, forKey: .address)
    try container.encode(color.rawValue, forKey: .color)
    try container.encode(name, forKey: .name)
  }
}

extension EthereumWallet: Equatable {
  public static func == (lhs: EthereumWallet, rhs: EthereumWallet) -> Bool {
    lhs.address.eip55Description == rhs.address.eip55Description
  }
}
