import Foundation

public struct HostConfigurationModel: Codable {
    public var configuration: [String: [HostConfigurationParameters]]

    public struct HostConfigurationParameters: Codable, Equatable, Hashable {
        public var host: String
        public var chainId: String
        var option: String?
        public var favicon: String?

        public init(host: String, chainId: String, option: String?, favicon: String?) {
            self.host = host
            self.chainId = chainId
            self.option = option
            self.favicon = favicon
        }

        public static func ==(_ left: HostConfigurationParameters, _ right: HostConfigurationParameters) -> Bool {
            left.host == right.host
        }
    }

    public init(configuration: [String: [HostConfigurationParameters]]) {
        self.configuration = configuration
    }
}

public struct HostConfigurationResolve: Codable {
    var address: String
    var chainId: String?
    var option: String?
    var favicon: String?
}
