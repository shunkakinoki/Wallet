import Foundation
import Domain
import Commons

protocol Transactionable {
    func signed(with request: Request, wallet: EthereumWallet) async throws -> Signature
}
