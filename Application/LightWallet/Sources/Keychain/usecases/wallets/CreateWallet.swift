import Commons
import Domain
import Foundation

public protocol CreateWallet {
  func create() throws
}

public final class CreateWalletImp: CreateWallet {

  private let secureStorage: SecureStoraging
  private let ethereumAccount: EthereumAccount
  private let generateMnemonic: GenerateMnemonic
  private let importWallet: ImportWallet
  private let importKeyStore: ImportKeyStore

  public convenience init() {
    self.init(
      secureStorage: SecureStorage(),
      ethereumAccount: EthereumAccount(),
      generateMnemonic: GenerateMnemonicImp(),
      importWallet: ImportWalletImp(),
      importKeyStore: ImportKeyStoreImp()
    )
  }

  private init(
    secureStorage: SecureStoraging,
    ethereumAccount: EthereumAccount,
    generateMnemonic: GenerateMnemonic,
    importWallet: ImportWallet,
    importKeyStore: ImportKeyStore
  ) {
    self.secureStorage = secureStorage
    self.ethereumAccount = ethereumAccount
    self.generateMnemonic = generateMnemonic
    self.importWallet = importWallet
    self.importKeyStore = importKeyStore
  }

  public func create() throws {
    let accounts = try ethereumAccount.fetchSeeds().compactMap { $0 }
    guard let seedKeyStore = accounts.first(where: { $0.primary == true }) else {
      return try importNewHDWallet()
    }
    let newWallet = try generateNewWallet(with: seedKeyStore)
    try importKeyStore.keyStore(
      newWallet.privateKey, publicKey: newWallet.publicKey, type: .derivedWallet)
    try importKeyStore.updateSeedKeyStore(seedKeyStore, address: newWallet.address)
  }
}

// MARK: - Helpers
extension CreateWalletImp {
  private func generateNewWallet(with seedKeyStore: SeedKeyStore) throws -> (
    privateKey: Data, publicKey: PublicKey, address: String
  ) {
    let decrypt = try secureStorage.decrypt(seedKeyStore.id, cipherText: seedKeyStore.cipherText)
    let mnemonic = try EthereumMnemonic(bytes: decrypt.bytes())
    let privateKey = try mnemonic.generateExternalPrivateKey(
      at: UInt32(seedKeyStore.addresses.count))
    let publicKey = try privateKey.publicKey(compressed: false)
    let address = try EthereumAddress(publicKey: publicKey)
    return (privateKey: privateKey.data, publicKey: publicKey, address: address.eip55Description)
  }

  private func importNewHDWallet() throws {
    let mnemonic = try generateMnemonic.get(with: .word12)
    try importWallet.import(mnemonic.bytes(), type: .primaryMnemonic)
  }
}
