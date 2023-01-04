import Combine
import Domain
import Foundation
import Keychain
import Session

public final class ShowSeedPhraseViewModel: ObservableObject {

  private let account: EthereumAccount
  private let secureStorage: SecureStoraging
  private let address: String

  enum Error: Swift.Error {
    case seedPhraseNotFound
  }

  convenience init(address: String) {
    self.init(address: address, account: EthereumAccount(), secureStorage: SecureStorage())
  }

  init(address: String, account: EthereumAccount, secureStorage: SecureStoraging) {
    self.address = address
    self.account = account
    self.secureStorage = secureStorage
  }

  func getSeedPhrase() throws -> Data {
    let seedPhrases = try account.fetchSeeds().compactMap { $0 }

    guard
      let seedPhrase = seedPhrases.first(
        where: { $0.addresses.containsValue(value: self.address) }
      )
    else {
      throw Error.seedPhraseNotFound
    }

    let decryptedSeedPhrase = try secureStorage.decrypt(
      seedPhrase.id, cipherText: seedPhrase.cipherText)
    return decryptedSeedPhrase
  }
}
