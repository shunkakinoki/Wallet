import Foundation

public struct SeedKeyStore: Codable {
    public let id: String
    public let addresses: [Int: String]
    public let primary: Bool
    public let cipherText: Data

    public init(id: String, addresses: [Int: String], primary: Bool = false, cipherText: Data) {
        self.id = id
        self.addresses = addresses
        self.primary = primary
        self.cipherText = cipherText
    }
}
