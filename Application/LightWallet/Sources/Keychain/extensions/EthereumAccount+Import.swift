import Commons
import Domain
import Foundation

public enum ImportWalletType: Codable {
  case privateKey
  case mnemonic
  case primaryMnemonic
}
