import Foundation
import Domain

public protocol ChangeSelectedWalletProperties {
    func changeName(_ name: String) throws
    func changeColor(_ color: EthereumWalletColor) throws
}

public class ChangeSelectedWalletPropertiesImp: ChangeSelectedWalletProperties {

    private let sessionRepository: SessionRepository

    public convenience init() {
        self.init(sessionRepository: SessionRepositoryImp())
    }

    public init(sessionRepository: SessionRepository) {
        self.sessionRepository = sessionRepository
    }

    public func changeName(_ name: String) throws {
        try sessionRepository.changeSelectedWalletName(with: name)
    }

    public func changeColor(_ color: EthereumWalletColor) throws {
        try sessionRepository.changeSelectedWalletColor(with: color)
    }
}
