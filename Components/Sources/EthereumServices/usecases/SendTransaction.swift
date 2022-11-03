import Foundation
import Combine

public protocol SendTransaction {
    func signature(with signature: String) async throws -> String
}

public class SendTransactionImp: SendTransaction {

    private let repository: EthereumRepository

    convenience public init() {
        self.init(repository: EthereumRepositoryImp())
    }

    private init(repository: EthereumRepository) {
        self.repository = repository
    }

    public func signature(with signature: String) async throws -> String {
        try await repository.sendTransaction(with: signature)
    }
}
