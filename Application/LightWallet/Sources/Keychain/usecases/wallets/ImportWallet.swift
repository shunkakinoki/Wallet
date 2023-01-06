import Commons
import Foundation

public protocol ImportWallet {
  func `import`(_ bytes: ByteArray, type: ImportWalletType) throws
}

public final class ImportWalletImp: ImportWallet {

  private let importKeyStore: ImportKeyStore

  public convenience init() {
    self.init(importKeyStore: ImportKeyStoreImp())
  }

  private init(importKeyStore: ImportKeyStore) {
    self.importKeyStore = importKeyStore
  }

  public func `import`(_ bytes: ByteArray, type: ImportWalletType) throws {
    switch type {
    case .privateKey:
      try importPrivateKey(bytes: bytes)
    case .mnemonic:
      try importMnemonic(bytes: bytes)
    case .primaryMnemonic:
      try importMnemonic(bytes: bytes, isPrimary: true)
    }
  }

  private func importPrivateKey(bytes: ByteArray) throws {
    let privateKey = PrivateKey(rawBytes: bytes)
    let publicKey = try privateKey.publicKey(compressed: false)
    try importKeyStore.keyStore(privateKey.data, publicKey: publicKey, type: .privateKey)
  }

  private func importMnemonic(bytes: ByteArray, isPrimary: Bool = false) throws {
    let mnemonic = try EthereumMnemonic(bytes: bytes)
    let privateKey = try mnemonic.generateExternalPrivateKey(at: 0)
    let publicKey = try privateKey.publicKey(compressed: false)
    try importKeyStore.seedKeyStore(bytes, isPrimary: isPrimary)
    try importKeyStore.keyStore(privateKey.data, publicKey: publicKey, type: .mnemonic)
  }
}
