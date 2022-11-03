import Foundation
import Session

final class GetSelectedAccountSafariRequest: SafariExtensionRequest {

    private let getSelectedWallet: SelectedWallet

    public init(getSelectedWallet: SelectedWallet = SelectedWalletImp()) {
        self.getSelectedWallet = getSelectedWallet
    }

    var response: String? {
        do {
            let account = try getSelectedWallet.selected()
            let accountsEncoded = try JSONEncoder().encode(account.address.eip55Description)
            guard let output = String(data: accountsEncoded, encoding: .utf8) else {
                return nil
            }
            return output
        } catch {
            return "error"
        }
    }
}
