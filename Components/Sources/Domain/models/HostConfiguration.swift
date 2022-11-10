import Foundation
import Commons

public protocol HostConfiguration {
    func fetchHostsConfiguration() -> [HostConfigurationModel.HostConfigurationParameters]?
    func fetchHostsConfiguration(with host: String) -> HostConfigurationResolve?
    func update(configuration: HostConfigurationRequest) throws
    func delete(configuration: HostConfigurationRequest) throws
    func deleteAll() throws
}

public struct HostConfigurationImp: HostConfiguration {

    public let hostsDirectory: WriterDirectory
    public let ethereumAccount: EthereumAccount

    enum Error: Swift.Error {
        case fetchingSelectedWallet
        case retrievingHostConfiguration
    }

    public init(hostsDirectory: WriterDirectory = UserDefaultsWalletWriterDirectory(),
                ethereumAccount: EthereumAccount = EthereumAccount()) {
        self.hostsDirectory = hostsDirectory
        self.ethereumAccount = ethereumAccount
    }

    public func fetchHostsConfiguration() -> [HostConfigurationModel.HostConfigurationParameters]? {
        do {
            if let selectedAccount: EthereumWallet = try ethereumAccount.fetchSelectedWallet() {
                let hostConfigurations: [HostConfigurationModel] = try hostsDirectory.retrieve(objectType: HostConfigurationModel.self, at: "hostsDirectory").compactMap { $0 }
                let hostParameters = hostConfigurations.first?.configuration.first(where: { $0.key == selectedAccount.address.eip55Description })?.value
                return hostParameters
            }
        } catch {
            return nil
        }
        return nil
    }

    public func fetchHostsConfiguration(with host: String) -> HostConfigurationResolve? {
        do {
            if let selectedAccount: EthereumWallet = try ethereumAccount.fetchSelectedWallet() {
                let hostConfigurations: [HostConfigurationModel] = try hostsDirectory.retrieve(objectType: HostConfigurationModel.self, at: "hostsDirectory").compactMap { $0 }
                let hostParameters = hostConfigurations.first?.configuration.first(where: { $0.key == selectedAccount.address.eip55Description })?.value.first(where: { $0.host == host })
                return HostConfigurationResolve(address: selectedAccount.address.eip55Description, chainId: hostParameters?.chainId)
            }
        } catch {
            if let selectedAccount: EthereumWallet = try? ethereumAccount.fetchSelectedWallet() {
                return HostConfigurationResolve(address: selectedAccount.address.eip55Description)
            } else {
                return returnSelectedAddress()
            }
        }
        return returnSelectedAddress()
    }

    private func returnSelectedAddress() -> HostConfigurationResolve? {
        if let selectedAccount: EthereumWallet = try? ethereumAccount.fetchSelectedWallet() {
            return HostConfigurationResolve(address: selectedAccount.address.eip55Description)
        } else {
            return nil
        }
    }

    public func update(configuration: HostConfigurationRequest) throws {
        do {
            guard let account = try ethereumAccount.fetchSelectedWallet() else {
                throw Error.fetchingSelectedWallet
            }
            let config = HostConfigurationModel.HostConfigurationParameters(host: configuration.host, chainId: configuration.chainId ?? "", option: configuration.option, favicon: configuration.favicon)

            if let currentHosts = fetchHosts() {
                var configurationHosts = currentHosts

                if var parameters = fetchHostsParameters(with: account.address.eip55Description) {
                    parameters.addOrReplace(config)
                    configurationHosts.configuration[account.address.eip55Description] = parameters
                } else {
                    configurationHosts.configuration[account.address.eip55Description] = [config]
                }

                try hostsDirectory.write(configurationHosts, at: "hostsDirectory")

            } else {
                let hostConfiguration = HostConfigurationModel(configuration: [account.address.eip55Description: [config]])
                try hostsDirectory.write(hostConfiguration, at: "hostsDirectory")
            }
        } catch {
            throw Error.retrievingHostConfiguration
        }
    }

    public func delete(configuration: HostConfigurationRequest) throws {
        do {
            guard let account = try ethereumAccount.fetchSelectedWallet() else {
                throw Error.fetchingSelectedWallet
            }
            let config = HostConfigurationModel.HostConfigurationParameters(host: configuration.host, chainId: "", option: "", favicon: "")

            if let currentHosts = fetchHosts() {
                var configurationHosts = currentHosts
                configurationHosts.configuration.removeValue(forKey: configuration.host)
                try hostsDirectory.write(configurationHosts, at: "hostsDirectory")

            } else {
                let hostConfiguration = HostConfigurationModel(configuration: [account.address.eip55Description: [config]])
                var configurationHosts = hostConfiguration
                configurationHosts.configuration.removeValue(forKey: configuration.host)
                try hostsDirectory.write(configurationHosts, at: "hostsDirectory")
            }
        } catch {
            throw Error.retrievingHostConfiguration
        }
    }

    public func deleteAll() throws {
        do {
            guard let account = try ethereumAccount.fetchSelectedWallet() else {
                throw Error.fetchingSelectedWallet
            }     
            if let currentHosts = fetchHosts() {
                var configurationHosts = currentHosts
                configurationHosts.configuration[account.address.eip55Description] = []
                try hostsDirectory.write(configurationHosts, at: "hostsDirectory")

            } else {
                let hostConfiguration = HostConfigurationModel(configuration: [account.address.eip55Description: []])
                try hostsDirectory.write(hostConfiguration, at: "hostsDirectory")
            }
        } catch {
            throw Error.retrievingHostConfiguration
        }
    }

    private func fetchHosts() -> HostConfigurationModel? {
        do {
            let hostConfigurations: [HostConfigurationModel] = try hostsDirectory.retrieve(objectType: HostConfigurationModel.self, at: "hostsDirectory").compactMap { $0 }
            if let host = hostConfigurations.first {
                return host
            } else {
                return nil
            }
        } catch {
            return nil
        }
    }

    private func fetchHostsParameters(with address: String) -> [HostConfigurationModel.HostConfigurationParameters]? {
        do {
            let hostConfigurations: [HostConfigurationModel] = try hostsDirectory.retrieve(objectType: HostConfigurationModel.self, at: "hostsDirectory").compactMap { $0 }
            if let host = hostConfigurations.first, let parameters = host.configuration.first(where: { $0.key == address }) {
                return parameters.value
            } else {
                return nil
            }
        } catch {
            return nil
        }
    }
}
