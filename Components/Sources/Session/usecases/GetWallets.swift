import Domain
import Foundation

public protocol GetWallets {
  func get() throws -> [EthereumWallet]
}

public class GetWalletsImp: GetWallets {

  private let sessionRepository: SessionRepository

  public convenience init() {
    self.init(sessionRepository: SessionRepositoryImp())
  }

  public init(sessionRepository: SessionRepository) {
    self.sessionRepository = sessionRepository
  }

  public func get() throws -> [EthereumWallet] {
    try self.sessionRepository.getWallets()
  }
}
