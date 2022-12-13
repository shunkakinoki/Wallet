import Domain
import Foundation

public protocol SelectedWallet {
  func selected() throws -> EthereumWallet
}

public class SelectedWalletImp: SelectedWallet {

  private let sessionRepository: SessionRepository

  public convenience init() {
    self.init(sessionRepository: SessionRepositoryImp())
  }

  public init(sessionRepository: SessionRepository) {
    self.sessionRepository = sessionRepository
  }

  public func selected() throws -> EthereumWallet {
    try self.sessionRepository.getSelected()
  }
}
