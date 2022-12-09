import Domain
import Foundation
import Session

final class PostHostConfigurationSafariRequest: SafariExtensionRequest {

  private let postHostConfiguration: PostHostConfiguration
  private let parameters: Any?

  enum Error: Swift.Error {
    case decodingExtensionParameters
  }

  convenience init(parameters: Any?) {
    self.init(parameters: parameters, postHostConfiguration: PostHostConfigurationImp())
  }

  init(parameters: Any?, postHostConfiguration: PostHostConfiguration) {
    self.parameters = parameters
    self.postHostConfiguration = postHostConfiguration
  }

  var response: String? {
    do {
      let parameters = try parametersToStruct(parameters)
      try postHostConfiguration.post(from: parameters.toModel())
      return nil
    } catch {
      return error.localizedDescription
    }
  }
}

extension PostHostConfigurationSafariRequest {
  func parametersToStruct(_ parameters: Any?) throws -> PostConfigurationRequestModel {
    guard let parameters = parameters,
      let decodedParameters = parameters as? [String: Any]
    else { throw Error.decodingExtensionParameters }
    let signatureParameters = try JSONDecoder().decode(
      PostConfigurationRequestModel.self, from: decodedParameters.toData())
    return signatureParameters
  }
}
