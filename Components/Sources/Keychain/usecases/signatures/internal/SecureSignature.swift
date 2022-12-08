import Commons
import Foundation
import secp256k1

public final class SecureSignature: SecureSigning {

  enum Error: Swift.Error {
    case invalid
  }

  public init() {}

  public func signature(hash _hash: [UInt8], privateKey: Data) throws -> (
    v: UInt, r: ByteArray, s: ByteArray
  ) {
    let signature = try sign(hash: _hash, privateKey: privateKey)
    return (
      v: UInt(signature.recId), r: Array(signature.sign[0..<32]), s: Array(signature.sign[32..<64])
    )
  }

  internal func signHash(hash _hash: [UInt8], privateKey: Data) throws -> ByteArray {
    let signature = try sign(hash: _hash, privateKey: privateKey)
    return signature.sign
  }
}

extension SecureSignature {
  private func sign(hash _hash: [UInt8], privateKey: Data) throws -> (recId: Int32, sign: ByteArray)
  {
    var hash = _hash
    guard
      let sig = malloc(MemoryLayout<secp256k1_ecdsa_recoverable_signature>.size)?
        .assumingMemoryBound(to: secp256k1_ecdsa_recoverable_signature.self)
    else {
      throw Error.invalid
    }
    let ctx = secp256k1_context_create(UInt32(SECP256K1_CONTEXT_SIGN | SECP256K1_CONTEXT_VERIFY))!

    defer { free(sig) }

    guard secp256k1_ecdsa_sign_recoverable(ctx, sig, &hash, privateKey.bytes, nil, nil) == 1 else {
      throw Error.invalid
    }

    var output64 = ByteArray(repeating: 0, count: 65)
    var recid: Int32 = 0

    secp256k1_ecdsa_recoverable_signature_serialize_compact(ctx, &output64, &recid, sig)

    return (recId: recid, sign: output64)
  }
}
