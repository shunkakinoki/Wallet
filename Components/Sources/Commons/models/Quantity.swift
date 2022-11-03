import Foundation
import BigInt

public enum QuantityUnit: Int64 {
    case value = 1
    case gwei = 1_000_000_000
    case ether = 1_000_000_000_000_000_000
}

public struct Quantity: Codable {
    public private(set) var bigInteger: BigUInt

    public init(double: Double, unit: QuantityUnit? = .value) {
        guard let unit = unit else { self.bigInteger = BigUInt(double); return }
        let decimals = Int(log10(Double(unit.rawValue)))
        self.bigInteger = BigUInt(double) * BigUInt(10).power(decimals)
    }

    public init(bigInteger: BigUInt, unit: QuantityUnit? = .value) {
        guard let unit = unit else { self.bigInteger = bigInteger; return }
        let decimals = Int(log10(Double(unit.rawValue)))
        self.bigInteger = bigInteger * BigUInt(10).power(decimals)
    }

    public func toHex() -> String {
        bigInteger.bytes().hex()
    }
}

extension Quantity: RlpType {
    public func bytes() -> ByteArray {
        bigInteger.bytes()
    }
}
