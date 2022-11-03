import Foundation
import Session

final class GetLightConfigurationSafariRequest: SafariExtensionRequest {

    private let getWallets: GetWallets

    public init(getWallets: GetWallets = GetWalletsImp()) {
        self.getWallets = getWallets
    }

    var response: String? {
        do {
            let accounts = try getWallets.get()
            let serializedAccounts = accounts.reduce(into: [String: LightConfigurationAccountParameters]()) {
                $0[$1.address.eip55Description] = LightConfigurationAccountParameters(name: $1.name.addingPercentEncoding(withAllowedCharacters: .alphanumerics) ?? "", icon: $1.color.rawValue)
            }
            let configurationAccount = LightConfigurationAccount(accounts: serializedAccounts)
            let accountsEncoded = try JSONEncoder().encode(configurationAccount)
            guard let output = String(data: accountsEncoded, encoding: .utf8) else {
                return nil
            }
            return output
        } catch {
            return error.localizedDescription
        }
    }
}

struct LightConfigurationAccount {
    let accounts: [String: LightConfigurationAccountParameters]

    enum CodingKeys: String, CodingKey {
        case accounts
    }
}

extension LightConfigurationAccount: Encodable {
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(accounts, forKey: .accounts)
    }
}

struct LightConfigurationAccountParameters {
    let name: String
    let icon: String

    enum CodingKeys: String, CodingKey {
        case name
        case icon
    }
}

extension LightConfigurationAccountParameters: Encodable {
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(name, forKey: .name)
        try container.encode(icon, forKey: .icon)
    }
}
