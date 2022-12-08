import Commons
import CryptoSwift
import Foundation

public enum SignatureType {
  case personal
  case message
  case typed
}

public protocol Request {
  func bytes() throws -> ByteArray
  var chainId: Quantity { get }
}

public struct MessageRequest {

  public enum Error: Swift.Error {
    case retrievingPrivateKey
    case encodingPrefixData
  }

  public let message: String
  public let type: SignatureType

  public init(message: String, type: SignatureType) {
    self.message = message
    self.type = type
  }

  public func data() throws -> ByteArray {
    let message = Data(hex: message)
    switch type {
    case .message:
      return SHA3(variant: .keccak256).calculate(for: message.bytes)
    case .personal:
      guard let prefix = "\u{0019}Ethereum Signed Message:\n\(message.count)".data(using: .utf8)
      else {
        throw Error.encodingPrefixData
      }
      return SHA3(variant: .keccak256).calculate(for: (prefix + message).bytes)
    case .typed:
      return message.bytes
    }
  }
}

extension MessageRequest: Request {

  public func bytes() throws -> ByteArray {
    try data()
  }

  public var chainId: Quantity {
    Quantity(bigInteger: 0x0)
  }
}
