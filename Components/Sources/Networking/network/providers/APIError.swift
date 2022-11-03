import Foundation

public enum APIError: Error {
    case invalidQuery
    case statusCode(HTTPURLResponse)
    case invalidData
}
