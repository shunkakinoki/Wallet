import Foundation
import Commons

public enum ImportType {
    case privateKey
    case mnemonic
    case seed
}

public final class EthereumAccount: Identifiable {

    public let walletDirectory: WriterDirectory
    public let selectedDirectory: WriterDirectory

    public enum Error: Swift.Error {
        case fetchingSelectedWallet
        case importingMnemonic
    }

    public init(walletDirectory: WriterDirectory = DirectoryWalletWriterDirectory(fileSubfolder: "keystore/"),
                selectedDirectory: WriterDirectory = UserDefaultsWalletWriterDirectory()) {
        self.walletDirectory = walletDirectory
        self.selectedDirectory = selectedDirectory
    }
}

/// Fetch wallets stored in disk
extension EthereumAccount {
    public func fetchSeeds() throws -> [SeedKeyStore?] {
        let seedKeystores: [SeedKeyStore?] = try walletDirectory.retrieve(objectType: SeedKeyStore.self, at: "")
        return seedKeystores
    }

    public func fetchWallets() throws -> [EthereumWallet] {
        let keyStores: [KeyStore?] = try walletDirectory.retrieve(objectType: KeyStore.self, at: "")
        return try keyStores.compactMap { try $0?.toWallet() }
    }

    public func fetch(wallet: String) throws -> EthereumWallet? {
        let keyStores: [KeyStore?] = try walletDirectory.retrieve(objectType: KeyStore.self, at: "")
        return try keyStores
            .compactMap { try $0?.toWallet() }
            .first { $0.address.eip55Description == wallet }
    }
}

/// Delete Wallet Methods
extension EthereumAccount {
    public func delete(wallet: EthereumWallet) throws {
        try walletDirectory.delete(at: wallet.address.eip55Description)
    }
    
    public func deleteAll() throws {
        try walletDirectory.deleteAll()
    }
}

/// Update Wallet Methods
extension EthereumAccount {
    public func update(keyStore: KeyStore) throws {
        try walletDirectory.write(keyStore, at: keyStore.eip55Address)
    }
}

/// Selected Wallet Methods
extension EthereumAccount {
    public func setSelected(wallet: EthereumWallet) throws {
        try selectedDirectory.write(wallet.address.eip55Description, at: "selectedWallet")
    }

    public func fetchSelectedWallet() throws -> EthereumWallet? {
        return try retrieveSelectedEthereumWallet()
    }

    public func changeName(name: String) throws {
        guard let walletSelected = try retrieveSelectedKeyStore() else {
            throw Error.fetchingSelectedWallet
        }
        var selectedKeyStore = walletSelected
        selectedKeyStore.name = name
        try update(keyStore: selectedKeyStore)
    }

    public func changeColor(color: EthereumWalletColor) throws {
        guard let walletSelected = try retrieveSelectedKeyStore() else {
            throw Error.fetchingSelectedWallet
        }
        var selectedKeyStore = walletSelected
        selectedKeyStore.color = color
        try update(keyStore: selectedKeyStore)
    }

    private func retrieveSelectedEthereumWallet() throws -> EthereumWallet? {
        let selectedWallets: [String?] = try selectedDirectory.retrieve(objectType: String.self, at: "selectedWallet")
        guard let selectedWallet = selectedWallets.first as? String else {
            throw Error.fetchingSelectedWallet
        }
        let keystores: [KeyStore?] = try walletDirectory.retrieve(objectType: KeyStore.self, at: "selectedWallet")
        return try keystores
            .filter({ $0?.eip55Address == selectedWallet })
            .compactMap { try $0?.toWallet() }
            .first
    }

    private func retrieveSelectedKeyStore() throws -> KeyStore? {
        let selectedWallets: [String?] = try selectedDirectory.retrieve(objectType: String.self, at: "selectedWallet")
        guard let selectedWallet = selectedWallets.first as? String else {
            throw Error.fetchingSelectedWallet
        }
        let keystores: [KeyStore?] = try walletDirectory.retrieve(objectType: KeyStore.self, at: "")
        return try keystores
            .filter({ $0?.eip55Address == selectedWallet })
            .compactMap { $0 }
            .first
    }
}

extension RangeReplaceableCollection where Element: Equatable {

    mutating func addOrReplace(_ element: Element) {
        if let index = self.firstIndex(of: element) {
            self.replaceSubrange(index...index, with: [element])
        }
        else {
            self.append(element)
        }
    }
}
