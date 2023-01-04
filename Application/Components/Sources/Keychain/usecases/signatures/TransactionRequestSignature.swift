import BigInt
import CryptoSwift
import Domain
import Foundation

public final class TransactionRequestSignature: Transactionable {

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
      wallet.address.eip55Description, cipherText: wallet.cipherText)
    let signature = try signing.signature(hash: request.bytes(), privateKey: decrypt)
    let v: BigUInt

    if request.chainId.bigInteger == 0 {
      v = BigUInt(signature.v) + BigUInt(27)
    } else {
      let chainIdCalc = (request.chainId.bigInteger * BigUInt(2) + BigUInt(8))
      v = BigUInt(signature.v) + BigUInt(27) + chainIdCalc
    }

    return Signature(
      v: v.bytes(),
      r: Data(signature.r),
      s: Data(signature.s)
    )
  }
}
