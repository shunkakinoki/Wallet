import Commons
import Foundation

public class Signature {
  let v: ByteArray
  let r: Data
  let s: Data

  init(v: ByteArray, r: Data, s: Data) {
    self.v = v
    self.r = r
    self.s = s
  }

  public func rlp() -> [RlpType] {
    [v, r, s]
  }

  public func hex() -> String {
    let result = r.toHexString() + s.toHexString() + v.toHexString()
    return result.withHexPrefix
  }
}
