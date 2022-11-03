import Foundation

public struct HostConfigurationRequest {
    public let host: String
    public let chainId: String?
    public let option: String?
    public let favicon: String?

    public init(host: String, chainId: String?, option: String?, favicon: String?) {
        self.host = host
        self.chainId = chainId
        self.option = option
        self.favicon = favicon
    }
}
