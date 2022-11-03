import Foundation
import Session
import Commons
import Domain

final class PostChangeAccountSafariRequest: SafariExtensionRequest {

    private let parameters: Any?
    private let getWallet: GetWallet
    private let getWallets: GetWallets
    private let changeSelectedWallet: ChangeSelectedWallet

    public init(parameters: Any?,
                getWallet: GetWallet = GetWalletImp(),
                getWallets: GetWallets = GetWalletsImp(),
                changeSelectedWallet: ChangeSelectedWallet = ChangeSelectedWalletImp()) {
        self.parameters = parameters
        self.getWallets = getWallets
        self.getWallet = getWallet
        self.changeSelectedWallet = changeSelectedWallet
    }

    enum Error: Swift.Error {
        case encodingPrefixData
        case decodingExtensionParameters
    }

    var response: String? {
        do {
            let parameters = try parametersToStruct(parameters)
            let address = try EthereumAddress(hex: parameters.wallet)
            let wallet = try getWallet.get(from: address.eip55Description)
            try changeSelectedWallet.change(wallet)
            return try swapAccounts(wallet.address.eip55Description)
        } catch {
            return error.localizedDescription
        }
    }
}

extension PostChangeAccountSafariRequest {
    func swapAccounts(_ wallet: String) throws -> String? {
        let wallets = try getWallets.get()
        var stringAccounts = wallets.map { $0.address.eip55Description }
        stringAccounts.move(wallet, to: 0)
        let accountsEncoded = try JSONEncoder().encode(stringAccounts)
        guard let output = String(data: accountsEncoded, encoding: .utf8) else {
            return nil
        }
        return output
    }
    func parametersToStruct(_ parameters: Any?) throws -> PostChangeAccountRequestModel {
        guard let parameters = parameters,
              let decodedParameters = parameters as? [String: Any]
        else { throw Error.decodingExtensionParameters }
        let signatureParameters = try JSONDecoder().decode(PostChangeAccountRequestModel.self, from: decodedParameters.toData())
        return signatureParameters
    }
}
