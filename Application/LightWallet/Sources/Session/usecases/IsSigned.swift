import Domain
import Foundation

public protocol IsSigned {
  func get() -> Bool
}

public class IsSignedImp: IsSigned {

  private let account: EthereumAccount

  public convenience init() {
    self.init(account: EthereumAccount())
  }

  public init(account: EthereumAccount) {
    self.account = account
  }

  public func get() -> Bool {
    guard let accounts = try? account.fetchWallets(),
      !accounts.isEmpty
    else {
      return false
    }
    return true
  }
}
