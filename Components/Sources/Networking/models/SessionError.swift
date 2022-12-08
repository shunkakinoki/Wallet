import Foundation

enum SessionError: Error {
  case statusCode(HTTPURLResponse)
}
