import Domain
import Foundation

public protocol DeleteHostConfiguration {
  func delete(from request: DeleteHostConfigurationRequest) throws
}

public class DeleteHostConfigurationImp: DeleteHostConfiguration {

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

  public func delete(from request: DeleteHostConfigurationRequest) throws {
    return try sessionRepository.deleteHosts(with: request)
  }
}
