import Foundation
import Keychain
import Domain
import Commons

final public class OnboardingViewModel {

    private let generateMnemonic: GenerateMnemonic
    private let importWallet: ImportWallet

    convenience init() {
        self.init(
            generateMnemonic: GenerateMnemonicImp(),
            importWallet: ImportWalletImp()
        )
    }

    init(
        generateMnemonic: GenerateMnemonic,
        importWallet: ImportWallet
    ) {
        self.generateMnemonic = generateMnemonic
        self.importWallet = importWallet
    }

    func createMainWallet() {
        do {
            let mnemonic = try generateMnemonic.get(with: .word12)
            try importWallet.import(mnemonic.bytes(), type: .primaryMnemonic)
            AppOrchestra.home()
        } catch {
            print(error)
        }
    }

    private func sanitize(wallet: String) -> String {
        wallet.trimmingCharacters(in: .whitespacesAndNewlines)
            .split(separator: " ")
            .joined(separator: " ")
    }
}
