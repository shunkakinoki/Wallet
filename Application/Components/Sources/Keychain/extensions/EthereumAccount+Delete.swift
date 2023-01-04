import Domain
import Foundation

/// Deletes the key associated with it's account
extension EthereumAccount {
  public func deleteKey(with address: String) throws {
    let params: [String: Any] = [
      kSecClass as String: kSecClassKey,
      kSecAttrKeyType as String: kSecAttrKeyTypeECSECPrimeRandom,
      kSecAttrApplicationTag as String: address.data(using: .utf8),
    ]
    let _ = SecItemDelete(params as CFDictionary)
  }

  public func deleteAllKeys() throws {
    let params: [String: Any] = [
      kSecClass as String: kSecClassKey
    ]
    let _ = SecItemDelete(params as CFDictionary)
  }
}
