import Foundation
import Commons
import CryptoSwift
import MnemonicSwift
import secp256k1
import Domain

public final class EthereumMnemonic {

    private let privateKey: HDPrivateKey

    public enum Error: Swift.Error {
        case retrieveSeedBytes
    }

    public init(bytes: ByteArray) throws {
        let mnemonic = String(decoding: bytes, as: UTF8.self)
        let seed: ByteArray = try Mnemonic.deterministicSeedBytes(from: mnemonic)
        self.privateKey = try HDPrivateKey(seed: seed)
    }

    public func getAddress(at index: UInt32) throws -> EthereumAddress {
        let publicKey = try generateExternalPrivateKey(at: index)
            .publicKey(compressed: false)
        return try EthereumAddress(publicKey: publicKey)
    }

    public func getPublicKey(at index: UInt32) throws -> PublicKey {
        try generateExternalPrivateKey(at: index).publicKey(compressed: true)
    }

    public func generateExternalPrivateKey(at index: UInt32) throws -> HDPrivateKey {
        return try ethereumPrivateKey()
            .child(at: index)
    }
}

extension EthereumMnemonic {
    private func ethereumPrivateKey() throws -> HDPrivateKey {
        return try privateKey.child()
    }
}
