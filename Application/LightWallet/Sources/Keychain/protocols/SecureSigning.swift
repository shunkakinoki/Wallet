import Commons
import Foundation

public protocol SecureSigning {
  func signature(hash _hash: [UInt8], privateKey: Data) throws -> (
    v: UInt, r: ByteArray, s: ByteArray
  )
}
