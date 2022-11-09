import Foundation
import Domain
import Keychain
import Session
import Commons

public final class ProfileSelectorViewModel: ObservableObject {
    @Published var wallets = [EthereumWallet]()

    private let account: EthereumAccount
    private let getTotalWallets: GetWallets
    private let walletCreation: CreateWallet
    private let deleteWallet: DeleteWallet

    public init(
        account: EthereumAccount = EthereumAccount(),
        getTotalWallets: GetWallets = GetWalletsImp(),
        walletCreation: CreateWallet = CreateWalletImp(),
        deleteWallet: DeleteWallet = DeleteWalletImp()
    ) {
        self.account = account
        self.getTotalWallets = getTotalWallets
        self.walletCreation = walletCreation
        self.deleteWallet = deleteWallet
    }

    public func getWallets() {
        do {
            self.wallets = try getTotalWallets.get().sorted()
        } catch {
            print(error)
        }
    }

    public func select(wallet: EthereumWallet) {
        do {
            try self.account.setSelected(wallet: wallet)
        } catch {
            print(error)
        }
    }

    public func selectedWallet() -> EthereumWallet? {
        do {
            return try account.fetchSelectedWallet()
        } catch {
            return nil
        }
    }

    public func deleteWallet(with wallet: EthereumWallet) throws {
        if wallets.count == 1 {
            try deleteWallet.deleteAll()
            AppOrchestra.onboarding()
            return
        }
        wallets.removeAll(where: { $0.address.eip55Description == wallet.address.eip55Description })
        try deleteWallet.delete(wallet)
        if selectedWallet() == nil { selectLastWallet() }
    }

    private func selectLastWallet() {
        if let wallet = wallets.last {
            select(wallet: wallet)
        }
    }

    public func createWallet() {
        do {
            try walletCreation.create()
        } catch {
            print(error)
        }
    }
}
