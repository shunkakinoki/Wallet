import Foundation
import Domain

public protocol PostHostConfiguration {
    func post(from request: HostConfigurationRequest) throws
}

public class PostHostConfigurationImp: PostHostConfiguration {

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

    public func post(from request: HostConfigurationRequest) throws {
        return try sessionRepository.updateHosts(with: request)
    }
}
