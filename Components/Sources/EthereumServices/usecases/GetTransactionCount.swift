import Foundation
import Combine

public protocol GetTransactionCount {
    func count(using address: String) async throws -> String
}

public class GetTransactionCountImp: GetTransactionCount {

    private let repository: EthereumRepository

    convenience public init() {
        self.init(repository: EthereumRepositoryImp())
    }

    private init(repository: EthereumRepository) {
        self.repository = repository
    }

    public func count(using address: String) async throws -> String {
        try await repository.getTransactionCount(address: address)
    }
}
