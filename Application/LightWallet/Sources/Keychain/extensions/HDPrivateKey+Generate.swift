import Commons
import Foundation
import secp256k1

extension HDPrivateKey {
  func generatePrivateKey(_ privateKey: ByteArray, pk: ArraySlice<UInt8>) throws -> ByteArray {

    guard
      let context = secp256k1_context_create(
        UInt32(SECP256K1_CONTEXT_SIGN | SECP256K1_CONTEXT_VERIFY))
    else {
      throw Error.privateKeyContext
    }

    defer {
      secp256k1_context_destroy(context)
    }

    var rawVariable = privateKey
    if rawVariable.withUnsafeMutableBytes({ privateKeyBytes -> Int32 in
      pk.withUnsafeBytes { factorBytes -> Int32 in
        guard let factorPointer = factorBytes.bindMemory(to: UInt8.self).baseAddress else {
          return 0
        }
        guard
          let privateKeyPointer = privateKeyBytes.baseAddress?.assumingMemoryBound(to: UInt8.self)
        else { return 0 }
        return secp256k1_ec_privkey_tweak_add(context, privateKeyPointer, factorPointer)
      }
    }) == 0 {
      throw Error.privateKeyContext
    }
    return rawVariable
  }
}
