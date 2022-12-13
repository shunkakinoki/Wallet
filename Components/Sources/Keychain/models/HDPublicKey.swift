import Commons
import Foundation
import secp256k1

final class HDPublicKey {

  private let raw: Data

  public init(raw: Data) {
    self.raw = raw
  }
}
