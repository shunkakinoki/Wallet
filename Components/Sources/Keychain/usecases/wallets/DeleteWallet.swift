import Foundation
import Commons
import Domain

public protocol DeleteWallet {
    func delete(_ wallet: EthereumWallet) throws
}

public final class DeleteWalletImp: DeleteWallet {

    private let account: EthereumAccount

    public convenience init() {
        self.init(account: EthereumAccount())
    }

    private init(account: EthereumAccount) {
        self.account = account
    }

    public func delete(_ wallet: EthereumWallet) throws {
        try account.delete(wallet: wallet)
        try account.deleteIndex(with: wallet.address.eip55Description)
        try account.deleteKey(with: wallet.address.eip55Description)
    }
}
