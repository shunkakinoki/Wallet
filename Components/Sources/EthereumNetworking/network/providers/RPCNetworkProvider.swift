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
  ) async throws -> T where T: Decodable {
    guard
      let request = try? getRequest(
        for: URL(string: query.service.baseUrl),
        body: query.body,
        and: query.headers
      )
    else { throw APIError.invalidQuery }
    let (data, response) = try await networkSession.data(for: request)
    if let response = response as? HTTPURLResponse,
      (200..<300).contains(response.statusCode) == false
    {
      throw APIError.statusCode(response)
    }
    guard let parsedData = try? JSONDecoder().decode(T.self, from: data) else {
      throw APIError.invalidData
    }
    return parsedData
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
