import BigInt
import Commons
import Domain
import Foundation

struct TransactionMetadata {

  enum Error: Swift.Error {
    case unexpected
  }

  static func getMetadata(to: EthereumAddress, from: EthereumAddress, value: Data) async throws -> (
    BigUInt, BigUInt, BigUInt
  ) {
    let getGas: GetGas = GetGasImp()
    let getTransactionCount: GetTransactionCount = GetTransactionCountImp()
    let price = try await getGas.price()
    let estimate = try await getGas.estimate(
      to: to.eip55Description,
      from: from.eip55Description,
      value: value.toHexString().withHexPrefix)
    let transactionCount = try await getTransactionCount.count(using: from.eip55Description)
    guard let intPrice = BigUInt(price.noHexPrefix, radix: 16),
      let intEstimate = BigUInt(estimate.noHexPrefix, radix: 16),
      let intTransactionCount = BigUInt(transactionCount.noHexPrefix, radix: 16)
    else {
      throw Error.unexpected
    }
    return (intPrice, intEstimate, intTransactionCount)
  }
}
