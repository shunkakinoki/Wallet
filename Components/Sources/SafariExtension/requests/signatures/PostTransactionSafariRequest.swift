import BigInt
import Commons
import Domain
import EthereumServices
import Foundation
import Keychain
import Session

final class PostTransactionSafariRequest: SafariExtensionRequest {

  private let parameters: Any?
  private let getWallet: GetWallet
  private let signature: TransactionRequestSignature

  public init(
    parameters: Any?, getWallet: GetWallet = GetWalletImp(),
    signature: TransactionRequestSignature = TransactionRequestSignature()
  ) {
    self.parameters = parameters
    self.getWallet = getWallet
    self.signature = signature
  }

  enum Error: Swift.Error {
    case decodingExtensionParameters
  }

  var response: String? {
    do {
      let parameters = try parametersToStruct(parameters)
      let from = try EthereumAddress(hex: parameters.from)
      let transactionRequest = TransactionRequest(
        to: try EthereumAddress(hex: parameters.to),
        value: Quantity(bigInteger: BigUInt(parameters.value)),
        gasPrice: Quantity(bigInteger: BigUInt(parameters.gasPrice)),
        gas: Quantity(bigInteger: BigUInt(parameters.gas)),
        nonce: Quantity(bigInteger: BigUInt(parameters.nonce)),
        chainId: Quantity(bigInteger: BigUInt(parameters.chainId)),
        data: Data(hex: parameters.data)
      )
      let transactionSigned = try signature.signed(
        with: transactionRequest, wallet: getWallet.get(from: from.eip55Description))
      let encodedSignature = try RLPEncoder().encode(
        transactionRequest.rlp() + transactionSigned.rlp())
      return encodedSignature.hex()
    } catch {
      return error.localizedDescription
    }
  }
}

extension PostTransactionSafariRequest {
  func parametersToStruct(_ parameters: Any?) throws -> PostTransactionRequestModel {
    guard let parameters = parameters,
      let decodedParameters = parameters as? [String: Any]
    else { throw Error.decodingExtensionParameters }
    let transactionParameters = try JSONDecoder().decode(
      PostTransactionRequestModel.self, from: decodedParameters.toData())
    return transactionParameters
  }
}
