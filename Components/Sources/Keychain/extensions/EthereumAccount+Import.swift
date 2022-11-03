import Foundation
import Domain
import Commons

public enum ImportWalletType: Codable {
    case privateKey
    case mnemonic
    case primaryMnemonic
}

