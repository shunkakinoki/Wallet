import Foundation
import Security

public protocol SecureKeychain {
    func SecKeyCreateRandomKey(_ parameters: CFDictionary,
                               _ error: UnsafeMutablePointer<Unmanaged<CFError>?>) -> SecKey?
    func SecKeyCopyPublicKey(_ key: SecKey) -> SecKey?
    func SecItemAdd(_ attributes: CFDictionary,
                    _ result: UnsafeMutablePointer<CFTypeRef?>?) -> OSStatus
    func SecItemCopyMatching(_ query: CFDictionary,
                             _ result: UnsafeMutablePointer<CFTypeRef?>?) -> OSStatus
    func SecKeyCreateEncryptedData(_ key: SecKey,
                                   _ algorithm: SecKeyAlgorithm,
                                   _ plaintext: CFData,
                                   error: UnsafeMutablePointer<Unmanaged<CFError>?>) -> CFData?
    func SecKeyCreateDecryptedData(_ key: SecKey,
                                   _ algorithm: SecKeyAlgorithm,
                                   _ plaintext: CFData,
                                   error: UnsafeMutablePointer<Unmanaged<CFError>?>) -> CFData?
}
