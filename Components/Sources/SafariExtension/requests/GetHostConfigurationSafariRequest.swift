import Foundation
import Session
import Domain

final class GetHostConfigurationSafariRequest: SafariExtensionRequest {

    private let getHostConfiguration: GetHostConfiguration
    private let parameters: Any?

    enum Error: Swift.Error {
        case decodingExtensionParameters
    }

    convenience init(parameters: Any?) {
        self.init(parameters: parameters, getHostConfiguration: GetHostConfigurationImp())
    }

    init(parameters: Any?, getHostConfiguration: GetHostConfiguration) {
        self.parameters = parameters
        self.getHostConfiguration = getHostConfiguration
    }

    var response: String? {
        do {
            let parameters = try parametersToStruct(parameters)
            if let configurations = getHostConfiguration.get(from: parameters.toModel()) {
                let hostsEncoded = try JSONEncoder().encode(configurations)
                guard let output = String(data: hostsEncoded, encoding: .utf8) else {
                    return nil
                }
                return output
            }
            return nil
        } catch {
            return error.localizedDescription
        }
    }
}

extension GetHostConfigurationSafariRequest {
    func parametersToStruct(_ parameters: Any?) throws -> PostConfigurationRequestModel {
        guard let parameters = parameters,
              let decodedParameters = parameters as? [String: Any]
        else { throw Error.decodingExtensionParameters }
        let signatureParameters = try JSONDecoder().decode(PostConfigurationRequestModel.self, from: decodedParameters.toData())
        return signatureParameters
    }
}

extension PostConfigurationRequestModel {
    func toModel() -> HostConfigurationRequest {
        HostConfigurationRequest(
            host: self.host,
            chainId: self.chainId,
            option: self.option,
            favicon: self.favicon
        )
    }
}
