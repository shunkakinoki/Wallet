import BigInt
import Commons
import Domain
import EthereumServices
import Foundation
import Keychain
import Session

public final class PostSignatureSafariRequest: SafariExtensionRequest {

  private let parameters: Any?
  private let getWallet: GetWallet
  private let signatureType: SignatureType
  private let signature: PersonalMessageRequestSignature

  public init(
    parameters: Any?, getWallet: GetWallet = GetWalletImp(), signatureType: SignatureType,
    signature: PersonalMessageRequestSignature = PersonalMessageRequestSignature()
  ) {
    self.parameters = parameters
    self.getWallet = getWallet
    self.signatureType = signatureType
    self.signature = signature
  }

  enum Error: Swift.Error {
    case encodingPrefixData
    case decodingExtensionParameters
  }

  public var response: String? {
    do {
      let parameters = try parametersToStruct(parameters)
      let personalMessageRequest = MessageRequest(message: parameters.message, type: signatureType)
      let from = try EthereumAddress(hex: parameters.from)
      let messageSigned = try signature.signed(
        with: personalMessageRequest, wallet: getWallet.get(from: from.eip55Description))
      return messageSigned.hex()
    } catch {
      return error.localizedDescription
    }
  }
}

extension PostSignatureSafariRequest {
  func parametersToStruct(_ parameters: Any?) throws -> PostSignMessageRequestModel {
    guard let parameters = parameters,
      let decodedParameters = parameters as? [String: Any]
    else { throw Error.decodingExtensionParameters }
    let signatureParameters = try JSONDecoder().decode(
      PostSignMessageRequestModel.self, from: decodedParameters.toData())
    return signatureParameters
  }
}
