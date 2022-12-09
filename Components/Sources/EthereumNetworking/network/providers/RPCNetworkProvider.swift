import Combine
import Foundation

public final class RPCNetworkProvider: EthereumNetworkProvider {

  private let networkSession: URLSession

  public convenience init() {
    self.init(networkSession: .shared)
  }

  public init(networkSession: URLSession) {
    self.networkSession = networkSession
  }

  enum APIError: Error {
    case invalidQuery
    case statusCode(HTTPURLResponse)
    case invalidData
  }

  public func performRequest<T>(
    to query: Query
  ) -> AnyPublisher<T, Error> where T: Decodable {
    guard
      let request = try? getRequest(
        for: URL(string: query.service.baseUrl),
        body: query.body,
        and: query.headers
      )
    else { return Fail(error: NSError()).eraseToAnyPublisher() }
    return networkSession.dataTaskPublisher(for: request)
      .tryMap({ (data, response) -> Data in
        if let response = response as? HTTPURLResponse,
          (200..<300).contains(response.statusCode) == false
        {
          throw SessionError.statusCode(response)
        }
        return data
      })
      .mapError({ NSError(domain: $0.localizedDescription, code: 1) })
      .decode(as: T.self)
      .eraseToAnyPublisher()
  }

  private func getRequest(
    for url: URL?,
    body: Data?,
    and headers: [String: String]?
  ) throws -> URLRequest {
    var request = URLRequest(url: url!)
    request.httpMethod = "POST"
    if let data = body {
      request.httpBody = data
    }
    headers?.forEach {
      request.addValue($0.value, forHTTPHeaderField: $0.key)
    }
    return request
  }
}
