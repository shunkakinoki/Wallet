import Foundation
import Keychain
import Commons
import Domain

class ImportPrivateKeyViewModel: ObservableObject {

    @Published public var isValid = false

    private let account: EthereumAccount
    private let importWallet: ImportWallet

    convenience init() {
        self.init(account: EthereumAccount(), importWallet: ImportWalletImp())
    }

    init(account: EthereumAccount, importWallet: ImportWallet) {
        self.account = account
        self.importWallet = importWallet
    }

    func importKey(with bytes: ByteArray) {
        guard bytes.count == 32 else { return }
        do {
            try importWallet.import(bytes, type: .privateKey)
            AppOrchestra.home()
        } catch {
            print(error)
        }
    }

    func checkData(_ data: Data?) {
        guard let data = data, data.count == 66 || data.count == 64 else {
            return
        }
        self.isValid = true
    }
}
