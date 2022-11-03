import Foundation

struct PostConfigurationRequestModel: Decodable {
    let host: String
    let chainId: String?
    let option: String?
    let favicon: String?
}
