import Commons
import Foundation

public class RLPEncoder {

  public init() {}

  public func encode(_ input: RlpType) throws -> ByteArray {
    let bytes = input.bytes()
    if bytes.count == 1 && (0x00...0x7f).contains(bytes[0]) {
      return bytes
    } else if bytes.count < 56 || bytes.isEmpty {
      return encodeMedium(bytes, with: 0x80)
    } else {
      return encodeLong(bytes, with: 0xb7)
    }
  }

  public func encode(_ input: [RlpType]) throws -> ByteArray {
    var bytes = ByteArray()
    bytes = try input.flatMap { try encode($0) }
    if bytes.count <= 55 {
      return encodeMedium(bytes, with: 0xc0)
    }

    return encodeLong(bytes, with: 0xf7)
  }

  private func encodeMedium(_ input: ByteArray, with prefix: UInt8) -> ByteArray {
    var bytes = input
    let sign: UInt8 = prefix + UInt8(input.count)
    bytes.insert(sign, at: 0)
    return bytes
  }

  private func encodeLong(_ input: ByteArray, with prefix: UInt8) -> ByteArray {
    var bytes = input
    let lengthBytes = input.count.bytes()
    let sign: UInt8 = prefix + UInt8(lengthBytes.count)
    for i in (0..<lengthBytes.count).reversed() {
      bytes.insert(lengthBytes[i], at: 0)
    }
    bytes.insert(sign, at: 0)
    return bytes
  }
}
