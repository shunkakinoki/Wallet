import CryptoSwift
import Foundation

public typealias ByteArray = [UInt8]

extension ByteArray {
  public func data() -> Data {
    Data(bytes: self, count: self.count)
  }
  public func hex() -> String {
    return "0x\(self.toHexString())"
  }
}
