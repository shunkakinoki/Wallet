import XCTest

@testable import Commons

final class QuantityTests: XCTestCase {

  func test_ether_double_value() throws {
    let quantity = Quantity(double: 2.0, unit: .ether)
    XCTAssertEqual(quantity.bigInteger, 2_000_000_000_000_000_000)
  }

  func test_gwei_double_value() throws {
    let quantity = Quantity(double: 2.0, unit: .gwei)
    XCTAssertEqual(quantity.bigInteger, 2_000_000_000)
  }

  func test_value_double_value() throws {
    let quantity = Quantity(double: 2.0, unit: .value)
    XCTAssertEqual(quantity.bigInteger, 2)
  }

  func test_ether_integer_value() throws {
    let quantity = Quantity(bigInteger: 2, unit: .ether)
    XCTAssertEqual(quantity.bigInteger, 2_000_000_000_000_000_000)
  }

  func test_gwei_integer_value() throws {
    let quantity = Quantity(bigInteger: 2, unit: .gwei)
    XCTAssertEqual(quantity.bigInteger, 2_000_000_000)
  }

  func test_value_integer_value() throws {
    let quantity = Quantity(bigInteger: 2, unit: .value)
    XCTAssertEqual(quantity.bigInteger, 2)
  }
}
