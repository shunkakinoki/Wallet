import Commons
import Domain
import Foundation

protocol Transactionable {
  func signed(with request: Request, wallet: EthereumWallet) async throws -> Signature
}
