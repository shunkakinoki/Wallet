import Commons
import Foundation

internal protocol ExtendedPrivateKey {
  var data: Data { get }
  func publicKey(compressed: Bool) throws -> Commons.PublicKey
}
