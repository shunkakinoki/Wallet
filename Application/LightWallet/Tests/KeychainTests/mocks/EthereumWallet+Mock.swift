import Domain
import Foundation

extension EthereumWallet {
  internal static func walletDefault() throws -> EthereumWallet {
    EthereumWallet(
      address: try EthereumAddress(hex: "0x14791697260E4c9A71f18484C9f997B308e59325"),
      cipherText: Data(),
      type: .privateKey,
      timestamp: Date(),
      color: .green,
      name: "name"
    )
  }
}
