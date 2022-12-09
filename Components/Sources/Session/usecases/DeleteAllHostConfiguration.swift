import Domain
import Foundation

public protocol DeleteAllHostConfiguration {
  func deleteAll() throws
}

public class DeleteAllHostConfigurationImp: DeleteAllHostConfiguration {

  private let sessionRepository: SessionRepository

  enum Error: Swift.Error {
    case retrievingWallet
  }

  public convenience init() {
    self.init(sessionRepository: SessionRepositoryImp())
  }

  public init(sessionRepository: SessionRepository) {
    self.sessionRepository = sessionRepository
  }

  public func deleteAll() throws {
    return try sessionRepository.deleteAllHosts()
  }
}
