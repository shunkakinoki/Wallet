import Foundation
import CryptoSwift

public typealias ByteArray = [UInt8]

public extension ByteArray {
    func data() -> Data {
        Data(bytes: self, count: self.count)
    }
    func hex() -> String {
        return "0x\(self.toHexString())"
    }
}
