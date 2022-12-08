import Combine
import Foundation
import Networking

public struct RPCResult<T: Decodable>: Decodable {
  public let id: Int?
  public let result: T?
}

public protocol EthereumDataSource {
  func getEstimatedGas(to: String, from: String, value: String) async throws -> String
  func getGasPrice() async throws -> String
  func sendTransaction(with signature: String) async throws -> String
  func getTransactionCount(using address: String) async throws -> String
}

public final class EthereumDataSourceImp: EthereumDataSource {

  private let client: Client

  public convenience init() {
    self.init(client: APIClient(with: .rpc))
  }

  init(client: Client) {
    self.client = client
  }

  public func getEstimatedGas(to: String, from: String, value: String) async throws -> String {
    let query = GetEstimatedGasQuery(to: to, from: from, value: value)
    let result: RPCResult<String> = try await client.performRequest(to: query)
    return result.result!
  }

  public func getGasPrice() async throws -> String {
    let query = GetGasPriceQuery()
    let result: RPCResult<String> = try await client.performRequest(to: query)
    return result.result!
  }

  public func sendTransaction(with signature: String) async throws -> String {
    let query = SendRawTransactionQuery(signature: signature)
    let result: RPCResult<String> = try await client.performRequest(to: query)
    return result.result!
  }

  public func getTransactionCount(using address: String) async throws -> String {
    let query = GetTransactionCountQuery(address: address)
    let result: RPCResult<String> = try await client.performRequest(to: query)
    return result.result!
  }
}
