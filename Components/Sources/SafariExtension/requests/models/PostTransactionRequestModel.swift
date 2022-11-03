import Foundation
import Domain
import BigInt

struct PostTransactionRequestModel: Decodable {
    private enum CodingKeys: String, CodingKey {
        case to
        case from
        case value
        case gas
        case gasPrice
        case nonce
        case chainId
        case data
    }

    let to: String
    let from: String
    let value: Int
    let gas: Int
    let gasPrice: Int
    let nonce: Int
    let chainId: Int
    let data: String

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        to = try container.decode(String.self, forKey: .to)
        from = try container.decode(String.self, forKey: .from)
        value = Int(try container.decode(String.self, forKey: .value).dropFirst(2), radix: 16) ?? 0
        gas = Int(try container.decode(String.self, forKey: .gas).dropFirst(2), radix: 16) ?? 0
        gasPrice = Int(try container.decode(String.self, forKey: .gasPrice).dropFirst(2), radix: 16) ?? 0
        nonce = Int(try container.decode(String.self, forKey: .nonce).dropFirst(2), radix: 16) ?? 0
        chainId = Int(try container.decode(String.self, forKey: .chainId).dropFirst(2), radix: 16) ?? 0
        data = try container.decode(String.self, forKey: .data)
    }
}
