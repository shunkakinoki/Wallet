import Domain
import Foundation

public protocol ChangeSelectedWallet {
  func change(_ wallet: EthereumWallet) throws
}

public class ChangeSelectedWalletImp: ChangeSelectedWallet {

  private let sessionRepository: SessionRepository

  public convenience init() {
    self.init(sessionRepository: SessionRepositoryImp())
  }

  public init(sessionRepository: SessionRepository) {
    self.sessionRepository = sessionRepository
  }

  public func change(_ wallet: EthereumWallet) throws {
    try sessionRepository.changeSelected(with: wallet)
  }
}
