import Foundation
import Commons

public struct KeyStore: Codable {
    let eip55Address: String
    public let cipherText: Data
    let type: EthereumWalletType
    let timestamp: Date
    var color: EthereumWalletColor
    var name: String

    public init(
        eip55Address: String,
        cipherText: Data,
        type: EthereumWalletType,
        timestamp: Date,
        color: EthereumWalletColor,
        name: String
    ) {
        self.eip55Address = eip55Address
        self.cipherText = cipherText
        self.type = type
        self.timestamp = timestamp
        self.color = color
        self.name = name
    }
}

extension KeyStore {
    public func toWallet() throws -> EthereumWallet {
        EthereumWallet(
            address: try EthereumAddress(hex: eip55Address),
            cipherText: cipherText,
            type: type,
            timestamp: timestamp,
            color: color,
            name: name.count > 0 ? name : Constants.DEFAULT_NAME
        )
    }
}
