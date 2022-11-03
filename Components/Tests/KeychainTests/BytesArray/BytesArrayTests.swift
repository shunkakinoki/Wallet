import XCTest
@testable import Keychain
import Commons

class BytesArrayTests: XCTestCase {

    func test_bytes_to_data() throws {
        let bytes: ByteArray = [97, 98, 99, 100]
        XCTAssertEqual(bytes.data(), String("abcd").data(using: .utf8))
    }
    func test_bytes_to_hex() throws {
        let bytes: ByteArray = [97, 98, 99, 100]
        XCTAssertEqual(bytes.hex(), "0x61626364")
    }
}
