import Commons
import Domain
import Foundation

public protocol DeleteWallet {
  func delete(_ wallet: EthereumWallet) throws
  func deleteAll() throws
}

public final class DeleteWalletImp: DeleteWallet {

  private let account: EthereumAccount

  public convenience init() {
    self.init(account: EthereumAccount())
  }

  private init(account: EthereumAccount) {
    self.account = account
  }

  public func delete(_ wallet: EthereumWallet) throws {
    try account.delete(wallet: wallet)
    try account.deleteIndex(with: wallet.address.eip55Description)
    try account.deleteKey(with: wallet.address.eip55Description)
  }

  public func deleteAll() throws {
    try account.deleteAll()
    try account.deleteAllIndexes()
    try account.deleteAllKeys()
  }
}
