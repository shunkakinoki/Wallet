import Foundation
import Domain

public protocol DeleteHostConfiguration {
    func delete(from request: HostConfigurationRequest) throws
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

    public func delete(from request: HostConfigurationRequest) throws {
        return try sessionRepository.updateHosts(with: request)
    }
}
