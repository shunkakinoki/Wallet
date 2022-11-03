import Foundation

struct PostSignMessageRequestModel: Decodable {
    let from: String
    let message: String
}
