import BigInt
import Foundation

public protocol RlpType {
  func bytes() -> ByteArray
}

extension String: RlpType {
  public func bytes() -> ByteArray {
    Array(self.utf8)
  }
}

extension Int: RlpType {
  public func bytes() -> ByteArray {
    let bigInt = BigUInt(self)
    return bigInt.serialize().bytes
  }
}

extension UInt: RlpType {
  public func bytes() -> ByteArray {
    let bigInt = BigUInt(self)
    return bigInt.serialize().bytes
  }
}

extension BigUInt: RlpType {
  public func bytes() -> ByteArray {
    return self.serialize().bytes
  }
}

extension ByteArray: RlpType {
  public func bytes() -> ByteArray {
    self
  }
}

extension Data: RlpType {
  public func bytes() -> ByteArray {
    return self.bytes
  }
}
