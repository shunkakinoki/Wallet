import Combine
import Foundation

public final class RestAPINetworkProvider: NetworkProvider {

  private let networkSession: URLSession

  public convenience init() {
    self.init(networkSession: .shared)
  }

  public init(networkSession: URLSession) {
    self.networkSession = networkSession
  }

  public func performRequest<T>(
    to query: Query
  ) -> AnyPublisher<T, Error> where T: Decodable {
    guard
      let request = try? getRequest(
        for: URL(string: query.service.baseUrl + query.query),
        method: query.method.rawValue,
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
    method: String,
    body: Data?,
    and headers: [String: String]?
  ) throws -> URLRequest {
    var request = URLRequest(url: url!)
    request.httpMethod = method
    if let data = body {
      request.httpBody = data
    }
    headers?.forEach {
      request.addValue($0.value, forHTTPHeaderField: $0.key)
    }
    return request
  }
}
