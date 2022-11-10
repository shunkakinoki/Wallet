import Foundation
import Session
import Domain

final class DeleteAllHostConfigurationSafariRequest: SafariExtensionRequest {

    private let deleteAllHostConfiguration: DeleteAllHostConfiguration

    enum Error: Swift.Error {
        case decodingExtensionParameters
    }

    convenience init() {
        self.init( deleteAllHostConfiguration: DeleteAllHostConfigurationImp())
    }

    init(deleteAllHostConfiguration: DeleteAllHostConfiguration) {
        self.deleteAllHostConfiguration = deleteAllHostConfiguration
    }

    var response: String? {
        do {
            try deleteAllHostConfiguration.deleteAll()
            return nil
        } catch {
            return error.localizedDescription
        }
    }
}
