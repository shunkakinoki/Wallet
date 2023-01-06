import Commons
import Foundation
import Security

// Hugely influenced by Alphawallet's Wallet implementation (https://github.com/alphaWallet/alpha-wallet-ios/)
public final class SecureStorage: SecureStoraging {

  private let keychain: SecureKeychain

  enum Error: Swift.Error {
    case encryptingPrivateKey
    case decryptingPrivateKey
    case retrievingKey
    case generatingKey
    case creatingAlreadyGeneratedKey
  }

  enum Keys {
    static let accessGroup = "4Z47XRX22C.io.magic.light"
  }

  public init(keychain: SecureKeychain = KeychainWrapper()) {
    self.keychain = keychain
  }

  public func encrypt(_ address: String, privateKey: Data) throws -> CFData {
    let key: SecKey
    do {
      key = try getPrivateKey(with: address)
    } catch {
      key = try createKey(with: address)
    }
    var error: Unmanaged<CFError>?
    guard let publicKey = keychain.SecKeyCopyPublicKey(key),
      let ciphertext = keychain.SecKeyCreateEncryptedData(
        publicKey, .eciesEncryptionCofactorVariableIVX963SHA256AESGCM, privateKey as CFData,
        error: &error)
    else {
      throw error!.takeRetainedValue() as Swift.Error
    }
    return ciphertext
  }

  public func decrypt(_ address: String, cipherText: Data) throws -> Data {
    let params: [String: Any] = [
      kSecClass as String: kSecClassKey,
      kSecAttrKeyClass as String: kSecAttrKeyClassPrivate,
      kSecAttrApplicationTag as String: address.data(using: .utf8) as Any,
      kSecAttrAccessGroup as String: Keys.accessGroup,
      kSecReturnRef as String: true,
    ]
    var raw: CFTypeRef?
    let status = Security.SecItemCopyMatching(params as CFDictionary, &raw)
    guard status == errSecSuccess else { throw Error.decryptingPrivateKey }
    var error: Unmanaged<CFError>?
    guard
      let plainTextData = keychain.SecKeyCreateDecryptedData(
        // swiftlint:disable force_cast
        raw as! SecKey, .eciesEncryptionCofactorVariableIVX963SHA256AESGCM, cipherText as CFData,
        error: &error) as Data?
    else {
      throw Error.decryptingPrivateKey
    }
    return plainTextData
  }
}

// MARK: - Secure Enclave Handling
extension SecureStorage {
  private func createKey(with address: String) throws -> SecKey {
    let count = getPrivateKeyCount(with: address)
    guard count == 0 else { throw Error.creatingAlreadyGeneratedKey }
    let query = buildQuery(address)
    var error: Unmanaged<CFError>?
    guard let secKey = keychain.SecKeyCreateRandomKey(query as CFDictionary, &error) else {
      throw error!.takeRetainedValue() as Swift.Error
    }
    // swiftlint:disable force_cast
    return secKey as! SecKey
  }

  private func getPrivateKey(with address: String) throws -> SecKey {
    let params: [String: Any] = [
      kSecClass as String: kSecClassKey,
      kSecAttrKeyType as String: kSecAttrKeyTypeECSECPrimeRandom,
      kSecAttrApplicationTag as String: address.data(using: .utf8) as Any,
      kSecAttrAccessGroup as String: Keys.accessGroup,
      kSecReturnRef as String: true,
    ]
    var raw: CFTypeRef?
    let status = Security.SecItemCopyMatching(params as CFDictionary, &raw)
    guard status == errSecSuccess, let result = raw else {
      throw Error.retrievingKey
    }
    return result as! SecKey
  }

  private func getPrivateKeyCount(with address: String) -> Int {
    let params: [String: Any] = getQuery(address, limit: true)
    var raw: CFTypeRef?
    let status = keychain.SecItemCopyMatching(params as CFDictionary, &raw)
    if status == errSecSuccess, let all = raw as? [SecKey] {
      return all.count
    } else {
      return 0
    }
  }
}

// MARK: - Helpers
extension SecureStorage {
  private func getQuery(_ address: String, limit: Bool) -> [String: Any] {
    var params: [String: Any] = [
      kSecClass as String: kSecClassKey,
      kSecAttrKeyType as String: kSecAttrKeyTypeECSECPrimeRandom,
      kSecAttrApplicationTag as String: address.data(using: .utf8) as Any,
      kSecAttrAccessGroup as String: Keys.accessGroup,
      kSecReturnRef as String: true,
      kSecMatchLimit as String: kSecMatchLimitAll,
    ]
    if limit {
      params[kSecMatchLimit as String] = kSecMatchLimitAll
    }
    return params
  }
  private func buildQuery(_ address: String) -> [String: Any] {
    let access = SecAccessControlCreateWithFlags(
      kCFAllocatorDefault,
      kSecAttrAccessibleWhenUnlockedThisDeviceOnly,
      [.privateKeyUsage],
      nil
    )
    let result: [String: Any] = [
      kSecAttrKeyType as String: kSecAttrKeyTypeEC,
      kSecAttrKeySizeInBits as String: 256,
      kSecAttrTokenID as String: kSecAttrTokenIDSecureEnclave,
      kSecAttrAccessGroup as String: Keys.accessGroup,
      kSecPrivateKeyAttrs as String: [
        kSecAttrIsPermanent as String: true,
        kSecAttrApplicationTag as String: address.data(using: .utf8) as Any,
        kSecAttrAccessControl as String: access as Any,
      ],
    ]
    return result
  }
}
