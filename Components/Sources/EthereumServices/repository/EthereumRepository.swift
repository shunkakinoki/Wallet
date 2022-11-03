import Foundation
import Combine

public protocol EthereumRepository {
    func sendTransaction(with signature: String) async throws -> String
    func getEstimatedGas(to: String, from: String, value: String) async throws -> String
    func getGasPrice() async throws -> String
    func getTransactionCount(address: String) async throws -> String
}

public class EthereumRepositoryImp: EthereumRepository {

    private let dataSource: EthereumDataSource

    convenience public init() {
        self.init(dataSource: EthereumDataSourceImp())
    }

    private init(dataSource: EthereumDataSource) {
        self.dataSource = dataSource
    }

    public func getEstimatedGas(to: String, from: String, value: String) async throws -> String {
        try await dataSource.getEstimatedGas(to: to, from: from, value: value)
    }

    public func getGasPrice() async throws -> String {
        try await dataSource.getGasPrice()
    }

    public func sendTransaction(with signature: String) async throws -> String {
        try await dataSource.sendTransaction(with: signature)
    }

    public func getTransactionCount(address: String) async throws -> String {
        try await dataSource.getTransactionCount(using: address)
    }
}
