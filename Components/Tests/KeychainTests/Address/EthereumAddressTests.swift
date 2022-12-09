import Commons
import Domain
import XCTest

@testable import Keychain

class EthereumAddressTests: XCTestCase {

  func test_bytes_to_data() throws {
    let address = try EthereumAddress(hex: "0xd8dA6BF26964aF9D7eEd9e03E53415D37aA96045")
    XCTAssertEqual(address.eip55Description, "0xd8dA6BF26964aF9D7eEd9e03E53415D37aA96045")
  }

  func test_bytes_to_hex() throws {
    let address = try EthereumAddress(bytes: [
      216, 218, 107, 242, 105, 100, 175, 157, 126, 237,
      158, 3, 229, 52, 21, 211, 122, 169, 96, 69,
    ])
    XCTAssertEqual(address.eip55Description, "0xd8dA6BF26964aF9D7eEd9e03E53415D37aA96045")
  }

  func test_public_key_to_hex() throws {
    let publicKey = PublicKey(rawBytes: [
      0x5f, 0xf2, 0xea, 0x6b, 0x8d, 0x33, 0x78, 0x56, 0x47, 0xda, 0xd5, 0x3f, 0xf3, 0x15, 0x48,
      0xf8,
      0xd1, 0x73, 0x84, 0x5c, 0xab, 0xcc, 0xde, 0x40, 0xfe, 0x81, 0x0b, 0x9b, 0xc5, 0xfc, 0x20,
      0x39,
      0x40, 0x35, 0xc7, 0x17, 0x3c, 0x95, 0xa3, 0x52, 0x57, 0x6d, 0xec, 0x31, 0x24, 0xa8, 0x3f,
      0x65,
      0x81, 0xba, 0xe8, 0x50, 0xcf, 0x7d, 0x77, 0x0b, 0x12, 0xdf, 0x99, 0x5a, 0x32, 0x5b, 0x71,
      0x06,
    ])
    let address = try EthereumAddress(publicKey: publicKey)
    XCTAssertEqual(address.eip55Description, "0xb741D4700f58b9eCA9279486F6dcfC894AfEdAA1")
  }

  func test_failure_invalid_address() throws {
    XCTAssertThrowsError(try EthereumAddress(hex: "0xd8da6*f26964af9d7eed9e03e53415d37aa96045"))
  }

  func test_failure_invalid_address_lenght() throws {
    XCTAssertThrowsError(try EthereumAddress(hex: "0xd8da6bf26964af9d7eed9e03e53415d37aa960"))
  }

  func test_failure_invalid_checksum() throws {
    XCTAssertThrowsError(try EthereumAddress(hex: "0xd8da6bf26964af9D7eEd9e03e53415d37aa960"))
  }
}
