import Foundation
import Commons
import CryptoSwift

public struct EthereumAddress: AddressStringConvertible {

    private let address: ByteArray

    enum Constants {
        static let addressRegex = "^0x[a-fA-F0-9]{40}$"
    }

    public enum Error: Swift.Error {
        case invalidAddress
        case invalidPublicKey
        case incorrectLength
        case invalidCheckSum
    }

    /// Initialized an ethereum address with a string representation.
    public init(hex: String) throws {
        guard hex.count == 40 || hex.count == 42 else {
            throw Error.incorrectLength
        }
        if hex.count == 40 && hex.hasPrefix("0x") {
            throw Error.incorrectLength
        }
        self.address = ByteArray(hex: hex)

        guard let _ = hex.range(
            of: Constants.addressRegex,
            options: .regularExpression
        ) else {
            throw Error.invalidAddress
        }

        if hex.toCheckSumString != hex && hex.lowercased() != hex && hex.uppercased() != hex {
            throw Error.invalidCheckSum
        }
    }

    /// Initialized an ethereum address with an array of bytes.
    public init(bytes: ByteArray) throws {
        if bytes.count != 20 {
            throw Error.incorrectLength
        }
        self.address = bytes
    }

    /// Initialized an ethereum address with a public key.
    public init(publicKey: PublicKey) throws {
        guard publicKey.isValid() else {
            throw Error.invalidPublicKey
        }
        guard let address = publicKey.addressBytes() else {
            throw Error.invalidPublicKey
        }
        self.address = address
    }

    public var eip55Description: String {
        return "\(address.hex().toCheckSumString)"
    }
}

extension EthereumAddress: RlpType {
    public func bytes() -> ByteArray {
        address
    }
}

