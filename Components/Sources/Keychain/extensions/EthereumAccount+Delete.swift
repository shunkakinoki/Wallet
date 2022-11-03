import Foundation
import Domain

/// Deletes the key associated with it's account
public extension EthereumAccount {
    func deleteKey(with address: String) throws {
        let params: [String: Any] = [
            kSecClass as String: kSecClassKey,
            kSecAttrKeyType as String: kSecAttrKeyTypeECSECPrimeRandom,
            kSecAttrApplicationTag as String: address.data(using: .utf8)
        ]
        let _ = SecItemDelete(params as CFDictionary)
    }
}
