import Foundation
import Keychain
import Commons
import Domain

class ImportHDWalletViewModel: ObservableObject {

    @Published public var isValid = false

    private let validateMnemonic: ValidateMnemonic
    private let importWallet: ImportWallet

    convenience init() {
        self.init(validateMnemonic: ValidateMnemonicImp(), importWallet: ImportWalletImp())
    }

    init(validateMnemonic: ValidateMnemonic, importWallet: ImportWallet) {
        self.validateMnemonic = validateMnemonic
        self.importWallet = importWallet
    }

    func importKey(with mnemonic: String, primary: Bool = true) {
        do {
            let seedPhrase = sanitize(wallet: mnemonic)
            try importWallet.import(seedPhrase.bytes(), type: primary ? .primaryMnemonic : .mnemonic)
            AppOrchestra.home()
        } catch {
            print(error)
        }
    }

    func checkSeed(_ seed: String?) {
        guard let seed = seed?.lowercased(), let _ = try? isValidMnemonic(seed: seed) else {
            return
        }
        self.isValid = true
    }

    func sanitize(wallet: String) -> String {
        wallet.trimmingCharacters(in: .whitespacesAndNewlines).split(separator: " ").joined(separator: " ")
    }

    func isValidMnemonic(seed: String) throws {
        try validateMnemonic.validate(seed)
    }
}
