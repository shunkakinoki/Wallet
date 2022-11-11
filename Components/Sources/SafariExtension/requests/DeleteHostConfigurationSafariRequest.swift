import Foundation
import Session
import Domain

final class DeleteHostConfigurationSafariRequest: SafariExtensionRequest {

    private let deleteHostConfiguration: DeleteHostConfiguration
    private let parameters: Any?

    enum Error: Swift.Error {
        case decodingExtensionParameters
    }

    convenience init(parameters: Any?) {
        self.init(parameters: parameters, deleteHostConfiguration: DeleteHostConfigurationImp())
    }

    init(parameters: Any?, deleteHostConfiguration: DeleteHostConfiguration) {
        self.parameters = parameters
        self.deleteHostConfiguration = deleteHostConfiguration
    }

    var response: String? {
        do {
            let parameters = try parametersToStruct(parameters)
            try deleteHostConfiguration.delete(from: parameters.toModel())
            return nil
        } catch {
            return error.localizedDescription
        }
    }
}

extension DeleteHostConfigurationSafariRequest {
    func parametersToStruct(_ parameters: Any?) throws -> DeleteConfigurationRequestModel {
        guard let parameters = parameters,
              let decodedParameters = parameters as? [String: Any]
        else { throw Error.decodingExtensionParameters }
        let signatureParameters = try JSONDecoder().decode(DeleteConfigurationRequestModel.self, from: decodedParameters.toData())
        return signatureParameters
    }
}

extension DeleteConfigurationRequestModel {
    func toModel() -> DeleteHostConfigurationRequest {
        DeleteHostConfigurationRequest(
            host: self.host
        )
    }
}
