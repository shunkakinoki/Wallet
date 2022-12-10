import Combine
import Domain
import Foundation
import Networking

public protocol TokensDataSource {
  func getTokens(from address: String) async throws -> [Token]
}

public final class TokensDataSourceImp: TokensDataSource {

  private let client: WsNetworkProvider

  public convenience init() {
    self.init(client: WsNetworkProviderImp())
  }

  init(client: WsNetworkProvider) {
    self.client = client
  }

  public func getTokens(from address: String) async throws -> [Token] {
    let query = GetTokensQuery(address: address)
    let request = try await client.performRequest(to: query)
    let token = try JSONDecoder().decode([TokenDataModel].self, from: request)
    return token.first!.payload.assets
      .filter { $0.value.asset.decimals != 0 }
      .map { $0.value.toDomain() }
      .sorted { $0.value > $1.value }
  }
}

extension Double {
  public func toString() -> String {
    let formatter = NumberFormatter()
    formatter.numberStyle = .decimal
    formatter.maximumFractionDigits = 2
    return formatter.string(from: self as NSNumber) ?? "0"
  }
}
