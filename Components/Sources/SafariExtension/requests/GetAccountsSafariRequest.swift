import Foundation
import Session

final class GetAccountsSafariRequest: SafariExtensionRequest {

    private let getWallets: GetWallets
    private let getSelected: SelectedWallet

    public init(getWallets: GetWallets = GetWalletsImp(),
                getSelected: SelectedWallet = SelectedWalletImp()) {
        self.getWallets = getWallets
        self.getSelected = getSelected
    }

    var response: String? {
        do {
            let accounts = try getWallets.get()
            let selectedAccount = try getSelected.selected()
            var stringAccounts = accounts.map { $0.address.eip55Description }
            stringAccounts.move(selectedAccount.address.eip55Description, to: 0)
            let accountsEncoded = try JSONEncoder().encode(stringAccounts)
            guard let output = String(data: accountsEncoded, encoding: .utf8) else {
                return nil
            }
            return output
        } catch {
            return error.localizedDescription
        }
    }
}
