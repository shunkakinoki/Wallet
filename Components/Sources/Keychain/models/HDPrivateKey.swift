import BigInt
import Commons
import CryptoSwift
import Foundation

public final class HDPrivateKey: ExtendedPrivateKey {

  private let key: ByteArray
  private let chainCode: ByteArray
  private let depth: UInt32
  private let parentFingerprint: UInt32
  private let childNumber: UInt32

  enum Error: Swift.Error {
    case privateKeyContext
  }

  public init(seed: ByteArray) throws {
    let hmac = HMAC(key: "Bitcoin seed".data(using: .ascii)!.bytes, variant: .sha2(.sha512))
    let output = try! hmac.authenticate(seed.bytes)
    self.key = ByteArray(output[0..<32])
    self.chainCode = ByteArray(output[32..<64])
    self.depth = 0
    self.parentFingerprint = 0
    self.childNumber = 0
  }

  private init(
    key: ByteArray, chainCode: ByteArray, depth: UInt32, parentFingerprint: UInt32,
    childNumber: UInt32
  ) {
    self.key = key
    self.chainCode = chainCode
    self.depth = depth
    self.parentFingerprint = parentFingerprint
    self.childNumber = childNumber
  }
}

//MARK: - Public Key
extension HDPrivateKey {
  public func publicKey(compressed: Bool) throws -> PublicKey {
    try PrivateKey(rawBytes: key).publicKey(compressed: compressed)
  }
}

//MARK: - Derive functions
extension HDPrivateKey {
  public func child() throws -> HDPrivateKey {
    try self
      .child(at: 44, hardened: true)
      .child(at: 60, hardened: true)
      .child(at: 0, hardened: true)
      .child(at: 0)
  }

  public func child(at index: UInt32, hardened: Bool = false) throws -> HDPrivateKey {
    let pubKey = try self.publicKey(compressed: true)

    var data = Data()

    if hardened {
      data.append(UInt8(0))
      data.append(self.key, count: key.count)
    } else {
      data.append(pubKey.data, count: pubKey.data.count)
    }

    let childIndex = (hardened ? (0x8000_0000 | index) : index).bigEndian
    data += childIndex

    let hmac = HMAC(key: chainCode.bytes, variant: .sha2(.sha512))
    let digest = try! hmac.authenticate(data.bytes)

    let pk = digest[0..<32]
    let chain = digest[32..<64]

    let fingerprint = pubKey.fingerprint
      .prefix(4)
      .withUnsafeBytes { $0.baseAddress!.assumingMemoryBound(to: UInt32.self).pointee }

    return HDPrivateKey(
      key: try generatePrivateKey(key, pk: pk).bytes(),
      chainCode: chain.bytes,
      depth: depth + 1,
      parentFingerprint: fingerprint.bigEndian,
      childNumber: childIndex.bigEndian
    )
  }
}

//MARK: - Serialization
extension HDPrivateKey {
  internal var data: Data {
    Data(key)
  }

  public func encoded() -> String {
    var extendedPrivateKeyData = Data()
    extendedPrivateKeyData += UInt32(0x0488_ADE4).bigEndian
    extendedPrivateKeyData += depth.littleEndian
    extendedPrivateKeyData += parentFingerprint.littleEndian
    extendedPrivateKeyData += childNumber.littleEndian
    extendedPrivateKeyData += chainCode
    extendedPrivateKeyData += UInt8(0)
    extendedPrivateKeyData += key
    let checksum = extendedPrivateKeyData.sha256().sha256().prefix(4)
    return Base58.encode(extendedPrivateKeyData + checksum.bytes)
  }
}
