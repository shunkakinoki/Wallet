import Foundation
import Combine

public protocol GetGas {
    func estimate(to: String, from: String, value: String) async throws -> String
    func price() async throws -> String
}

public class GetGasImp: GetGas {

    private let repository: EthereumRepository

    convenience public init() {
        self.init(repository: EthereumRepositoryImp())
    }

    private init(repository: EthereumRepository) {
        self.repository = repository
    }

    public func estimate(to: String, from: String, value: String) async throws -> String {
        try await repository.getEstimatedGas(to: to, from: from, value: value)
    }

    public func price() async throws -> String {
        try await repository.getGasPrice()
    }
}
