import Foundation
import Keychain

public final class SettingsViewModel: ObservableObject {
    private let deleteWallet: DeleteWallet
    
    init(deleteWallet: DeleteWallet = DeleteWalletImp()) {
        self.deleteWallet = deleteWallet
    }
    
    public func deleteAllAccounts() throws {
        try deleteWallet.deleteAll()
    }
}
