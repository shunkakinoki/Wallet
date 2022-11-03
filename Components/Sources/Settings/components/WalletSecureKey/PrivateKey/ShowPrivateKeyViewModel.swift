import Foundation
import Combine
import Session
import Keychain

public final class ShowPrivateKeyViewModel: ObservableObject {

    private let address: String
    private let getWallet: GetWallet
    private let secureStorage: SecureStoraging

    convenience init(address: String) {
        self.init(address: address, getWallet: GetWalletImp(), secureStorage: SecureStorage())
    }

    init(address: String, getWallet: GetWallet, secureStorage: SecureStoraging) {
        self.address = address
        self.getWallet = getWallet
        self.secureStorage = secureStorage
    }

    func getPrivateKey() throws -> Data {
        let wallet = try getWallet.get(from: address)
        return try secureStorage.decrypt(
            wallet.address.eip55Description,
            cipherText: wallet.cipherText
        )
    }
}
