import Combine
import Foundation

public final class RestAPINetowkrProvider: NetworkProvider {

  private let networkSession: URLSession

  public convenience init() {
    self.init(networkSession: .shared)
  }

  public init(networkSession: URLSession) {
    self.networkSession = networkSession
  }

  public func performRequest<T>(
    to query: Query
  ) async throws -> T where T: Decodable {
    guard
      let request = try? getRequest(
        for: URL(string: query.service.baseUrl + query.query),
        method: query.method.rawValue,
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
