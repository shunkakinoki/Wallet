import Commons
import Domain
import Foundation

public protocol ImportKeyStore {
  func keyStore(_ privateKey: Data, publicKey: PublicKey, type: EthereumWalletType) throws
  func seedKeyStore(_ bytes: ByteArray, isPrimary: Bool) throws
  func updateSeedKeyStore(_ seedKeyStore: SeedKeyStore, address: String) throws
}

public final class ImportKeyStoreImp: ImportKeyStore {

  private let account: EthereumAccount
  private let secureStorage: SecureStoraging

  convenience init() {
    self.init(
      account: EthereumAccount(),
      secureStorage: SecureStorage()
    )
  }

  private init(
    account: EthereumAccount,
    secureStorage: SecureStoraging
  ) {
    self.account = account
    self.secureStorage = secureStorage
  }

  public func keyStore(_ privateKey: Data, publicKey: PublicKey, type: EthereumWalletType) throws {
    let address = try EthereumAddress(publicKey: publicKey)
    let encryptedPrivateKey = try secureStorage.encrypt(
      address.eip55Description,
      privateKey: privateKey
    )
    let accountNumber = try account.updateIndex(with: address.eip55Description)
    let keyStore = KeyStore(
      eip55Address: address.eip55Description,
      cipherText: encryptedPrivateKey as Data,
      type: type,
      timestamp: Date(),
      color: EthereumWalletColor.random(),
      name: "My Wallet #\(accountNumber)"
    )
    try account.selectedDirectory.write(address.eip55Description, at: "selectedWallet")
    try account.walletDirectory.write(keyStore, at: address.eip55Description)
  }

  public func seedKeyStore(_ bytes: ByteArray, isPrimary: Bool) throws {
    let seedPhraseId = UUID().uuidString
    let mnemonic = try EthereumMnemonic(bytes: bytes)
    let encryptedPrivateKey = try secureStorage.encrypt(seedPhraseId, privateKey: bytes.data())
    let seedKeyStore = SeedKeyStore(
      id: seedPhraseId,
      addresses: try getAddresses(with: mnemonic),
      primary: isPrimary,
      cipherText: encryptedPrivateKey as Data
    )
    try account.walletDirectory.write(seedKeyStore, at: seedPhraseId)
  }

  public func updateSeedKeyStore(_ seedKeyStore: SeedKeyStore, address: String) throws {
    var newAccount = seedKeyStore.addresses
    newAccount[seedKeyStore.addresses.count] = address
    let seedKeystore = SeedKeyStore(
      id: seedKeyStore.id,
      addresses: newAccount,
      primary: seedKeyStore.primary,
      cipherText: seedKeyStore.cipherText
    )
    try account.walletDirectory.write(seedKeystore, at: seedKeyStore.id)
  }

  private func getAddresses(with mnemonic: EthereumMnemonic) throws -> [Int: String] {
    // REFACTOR: Retrieve all addresses from master seed phrase (https://github.com/bitcoin/bips/blob/master/bip-0044.mediawiki#account-discovery)
    return [0: try mnemonic.getAddress(at: 0).eip55Description]
  }
}
