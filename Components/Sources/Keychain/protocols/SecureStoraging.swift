import Foundation
import Commons

public protocol SecureStoraging {
    func encrypt(_ address: String, privateKey: Data) throws -> CFData
    func decrypt(_ address: String, cipherText: Data) throws -> Data
}

// REFACTOR: Sourcery or Cuckoo
public class SecureStorageMock: SecureStoraging {

    public init() { }

    var privateKeys: [String: String] {
        ["0x14791697260E4c9A71f18484C9f997B308e59325": "0x0123456789012345678901234567890123456789012345678901234567890123",
         "0xD351c7c627ad5531Edb9587f4150CaF393c33E87": "0x51d1d6047622bca92272d36b297799ecc152dc2ef91b229debf84fc41e8c73ee",
         "0xe7deA7e64B62d1Ca52f1716f29cd27d4FE28e3e1": "0x09a11afa58d6014843fd2c5fd4e21e7fadf96ca2d8ce9934af6b8e204314f25c"]
    }

    public func encrypt(_ address: String, privateKey: Data) throws -> CFData {
        return Data() as CFData
    }

    public func decrypt(_ address: String, cipherText: Data) throws -> Data {
        return Data(hex: privateKeys[address]!)
    }
}
