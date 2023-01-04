import Domain
import Foundation

public protocol GetHostConfiguration {
  func get() -> [HostConfigurationModel.HostConfigurationParameters]?
  func get(from request: HostConfigurationRequest) -> HostConfigurationResolve?
}

public class GetHostConfigurationImp: GetHostConfiguration {

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

  public func get() -> [HostConfigurationModel.HostConfigurationParameters]? {
    return sessionRepository.getHostParameters()
  }

  public func get(from request: HostConfigurationRequest) -> HostConfigurationResolve? {
    return sessionRepository.getHostParameters(with: request.host)
  }
}
