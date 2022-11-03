import Foundation
import Domain

public protocol GetWallet {
    func get(from address: String) throws -> EthereumWallet
}

public class GetWalletImp: GetWallet {

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

    public func get(from address: String) throws -> EthereumWallet {
        guard let wallet = try self.sessionRepository.getWallets().first(
            where: { $0.address.eip55Description == address }
        ) else {
            throw Error.retrievingWallet
        }
        return wallet
    }
}

public class GetWalletMock: GetWallet {
    public init() { }
    public func get(from address: String) throws -> EthereumWallet {
        EthereumWallet(
            address: try EthereumAddress(hex: "0x14791697260e4c9a71f18484c9f997b308e59325"),
            cipherText: Data(),
            type: .privateKey,
            timestamp: Date(),
            color: .green,
            name: "name"
        )
    }
}
