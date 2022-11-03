import Domain
import CryptoSwift
import BigInt
import Foundation
import Commons

public final class PersonalMessageRequestSignature: Transactionable {

    private let storage: SecureStoraging
    private let signing: SecureSigning

    public enum Error: Swift.Error {
        case retrievingPrivateKey
    }

    public init(
        storage: SecureStoraging = SecureStorage(),
        signing: SecureSigning = SecureSignature()
    ) {
        self.storage = storage
        self.signing = signing
    }

    public func signed(with request: Request, wallet: EthereumWallet) throws -> Signature {
        let decrypt = try storage.decrypt(
            wallet.address.eip55Description,
            cipherText: wallet.cipherText
        )
        let signature = try signing.signature(hash: request.bytes(), privateKey: decrypt)
        let v = BigUInt(signature.v) + BigUInt(27)
        return Signature(
            v: v.bytes(),
            r: Data(signature.r),
            s: Data(signature.s)
        )
    }
}
