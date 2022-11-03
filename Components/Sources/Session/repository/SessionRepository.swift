import Foundation
import Commons
import Domain

public protocol SessionRepository {
    // Wallets
    func changeSelected(with wallet: EthereumWallet) throws
    func getSelected() throws -> EthereumWallet
    func getWallets() throws -> [EthereumWallet]
    func changeSelectedWalletName(with name: String) throws
    func changeSelectedWalletColor(with color: EthereumWalletColor) throws

    //Hosts
    func getHostParameters() -> [HostConfigurationModel.HostConfigurationParameters]?
    func getHostParameters(with host: String) -> HostConfigurationResolve?
    func updateHosts(with host: HostConfigurationRequest) throws
}

public final class SessionRepositoryImp: SessionRepository {

    private let account: EthereumAccount
    private let hostConfiguration: HostConfiguration

    enum Error: Swift.Error {
        case retrievingSelectedWallet
    }

    public init(account: EthereumAccount = EthereumAccount(), hostConfiguration: HostConfiguration = HostConfigurationImp()) {
        self.account = account
        self.hostConfiguration = hostConfiguration
    }
}

//MARK: - Wallets Methods
extension SessionRepositoryImp {
    public func getSelected() throws -> EthereumWallet {
        guard let selectedWallet = try account.fetchSelectedWallet() else {
            throw Error.retrievingSelectedWallet
        }
        return selectedWallet
    }

    public func getWallets() throws -> [EthereumWallet] {
        return try account.fetchWallets()
    }

    public func changeSelected(with wallet: EthereumWallet) throws {
        try account.setSelected(wallet: wallet)
    }

    public func changeSelectedWalletName(with name: String) throws {
        try account.changeName(name: name)
    }

    public func changeSelectedWalletColor(with color: EthereumWalletColor) throws {
        try account.changeColor(color: color)
    }
}

//MARK: - Host Configuration
extension SessionRepositoryImp {

    public func getHostParameters() -> [HostConfigurationModel.HostConfigurationParameters]? {
        hostConfiguration.fetchHostsConfiguration()
    }

    public func getHostParameters(with host: String) -> HostConfigurationResolve? {
        hostConfiguration.fetchHostsConfiguration(with: host)
    }

    public func updateHosts(with host: HostConfigurationRequest) throws {
        try hostConfiguration.update(configuration: host)
    }
}
