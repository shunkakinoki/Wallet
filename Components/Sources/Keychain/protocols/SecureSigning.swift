import Foundation
import Commons

public protocol SecureSigning {
    func signature(hash _hash: Array<UInt8>, privateKey: Data) throws -> (v: UInt, r: ByteArray, s: ByteArray)
}
