import Commons
import Domain
import Foundation
import Keychain

//struct TransactionBuilder {
//
//    static func transaction(with wallet: EthereumWallet, to address: String) async throws -> String {
//        let (price, estimate, transactionCount) = try await TransactionMetadata.getMetadata(
//            to: try EthereumAddress(hex: address),
//            from: wallet.address,
//            value: contract.data()
//        )
//        let transactionRequest = TransactionRequest(
//            to: try EthereumAddress(hex: address),
//            value: Quantity(bigInteger: 0),
//            gasPrice: Quantity(bigInteger: price),
//            gas: Quantity(bigInteger: estimate),
//            nonce: Quantity(bigInteger: transactionCount),
//            chainId: .goerli,
//            data: contract.data()
//        )
//        let transactionSigned = try await transactionRequest.signed(with: wallet)
//        let encodedSignature = try RLPEncoder().encode(transactionRequest.rlp() + transactionSigned.rlp())
//        return encodedSignature.hex()
//    }
//}
