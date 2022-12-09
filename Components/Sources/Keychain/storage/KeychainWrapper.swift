import Foundation
import Security

public final class KeychainWrapper: SecureKeychain {

  public init() {}

  public func SecKeyCreateRandomKey(
    _ parameters: CFDictionary, _ error: UnsafeMutablePointer<Unmanaged<CFError>?>
  ) -> SecKey? {
    Security.SecKeyCreateRandomKey(parameters, error)
  }

  public func SecKeyCopyPublicKey(_ key: SecKey) -> SecKey? {
    Security.SecKeyCopyPublicKey(key)
  }

  public func SecItemAdd(_ attributes: CFDictionary, _ result: UnsafeMutablePointer<CFTypeRef?>?)
    -> OSStatus
  {
    Security.SecItemAdd(attributes, result)
  }

  public func SecItemCopyMatching(
    _ query: CFDictionary, _ result: UnsafeMutablePointer<CFTypeRef?>?
  ) -> OSStatus {
    Security.SecItemCopyMatching(query, result)
  }

  public func SecKeyCreateEncryptedData(
    _ key: SecKey, _ algorithm: SecKeyAlgorithm, _ plaintext: CFData,
    error: UnsafeMutablePointer<Unmanaged<CFError>?>
  ) -> CFData? {
    Security.SecKeyCreateEncryptedData(key, algorithm, plaintext, error)
  }

  public func SecKeyCreateDecryptedData(
    _ key: SecKey, _ algorithm: SecKeyAlgorithm, _ plaintext: CFData,
    error: UnsafeMutablePointer<Unmanaged<CFError>?>
  ) -> CFData? {
    Security.SecKeyCreateDecryptedData(key, algorithm, plaintext, error)
  }
}
