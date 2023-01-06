import CryptoSwift
import Foundation

extension String {
  public var noHexPrefix: String {
    self.replacingOccurrences(of: "0x", with: "")
  }
  public var withHexPrefix: String {
    "0x\(self)"
  }

  public var toCheckSumString: String {
    let lowerCaseAddress = self.noHexPrefix.lowercased()
    let arr = Array(lowerCaseAddress)
    let keccaf = SHA3(variant: .keccak256).calculate(for: Array(lowerCaseAddress.utf8))
      .toHexString()
    let keccafArray = Array(keccaf)
    var result = ""
    for i in 0..<lowerCaseAddress.count {
      if let val = Int(String(keccafArray[i]), radix: 16), val >= 8 {
        result.append(arr[i].uppercased())
      } else {
        result.append(arr[i])
      }
    }
    return result.withHexPrefix
  }
}
