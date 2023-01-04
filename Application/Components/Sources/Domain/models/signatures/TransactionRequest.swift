import BigInt
import Commons
import CryptoSwift
import Foundation

public struct TransactionRequest {
  let to: EthereumAddress
  let value: Quantity
  let gasPrice: Quantity
  let gas: Quantity
  let nonce: Quantity
  public let chainId: Quantity
  let data: Data

  public init(
    to: EthereumAddress, value: Quantity, gasPrice: Quantity, gas: Quantity, nonce: Quantity,
    chainId: Quantity, data: Data
  ) {
    self.to = to
    self.value = value
    self.gasPrice = gasPrice
    self.gas = gas
    self.nonce = nonce
    self.chainId = chainId
    self.data = data
  }

  public func rlp() -> [RlpType] {
    [nonce, gasPrice, gas, to, value, data]
  }
}

extension TransactionRequest: Request {
  public func bytes() throws -> ByteArray {
    let rlpEncoded = try RLPEncoder().encode(self.rlp() + [self.chainId.bigInteger, 0, 0])
    return SHA3(variant: .keccak256).calculate(for: rlpEncoded.bytes())
  }
}
