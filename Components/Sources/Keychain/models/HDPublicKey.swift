import Foundation
import secp256k1
import Commons

final class HDPublicKey {

    private let raw: Data

    public init(raw: Data) {
        self.raw = raw
    }
}
