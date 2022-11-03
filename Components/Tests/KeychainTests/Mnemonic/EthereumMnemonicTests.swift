import XCTest
@testable import Keychain
import Commons
import Domain

final class EthereumMnemonicTests: XCTestCase {

    var seedPhrase: String!
    var seedBytes: ByteArray!
    var sut: EthereumMnemonic!

    // Useful tool: https://iancoleman.io/bip39/

    override func setUp() {
        self.seedPhrase = "final eight liquid monitor razor knee walnut border that soft salt van"
        self.seedBytes = seedPhrase.bytes()
    }

    func test_private_key_account_0() throws {
        self.sut = try EthereumMnemonic(bytes: seedBytes)
        let hexPrivateKey = try sut.generateExternalPrivateKey(at: 0).data.toHexString().withHexPrefix
        XCTAssertEqual(hexPrivateKey, "0x65b840595eb77c026916ffacd1839fa277b38af2209214244f12e1e88cf1cf03")
    }

    func test_public_key_account_0() throws {
        self.sut = try EthereumMnemonic(bytes: seedBytes)
        let privateKey = try sut.generateExternalPrivateKey(at: 0)
        let publicKey = try privateKey.publicKey(compressed: true)
        XCTAssertEqual(publicKey.data.toHexString().withHexPrefix, "0x034a76ce52484736497d1bcdd112469043b6bf0a7a1b05ad25a9ff7d145834b39e")
    }

    func test_address_account_0() throws {
        self.sut = try EthereumMnemonic(bytes: seedBytes)
        let privateKey = try sut.generateExternalPrivateKey(at: 0)
        let publicKey = try privateKey.publicKey(compressed: false)
        let address = try EthereumAddress(publicKey: publicKey)
        XCTAssertEqual(address.eip55Description, "0xC8f4D897cfE4a24A715268905aA731D3134f8e8f")
    }

    func test_private_key_accounts() throws {
        self.sut = try EthereumMnemonic(bytes: seedBytes)
        for i in 0..<10 {
            let expect = [
                "0x65b840595eb77c026916ffacd1839fa277b38af2209214244f12e1e88cf1cf03",
                "0xb76d0f36fbbac4942decfde76f519eb70fba309daf398c88a3231b98c3c531b0",
                "0x631128c1822e2744a8114fdd263172f43e6621e6462b66052abec37e7e48b9a1",
                "0x139c5745a5468696dc27aa2fbd42eeef3c000a3e32d91397517f891010641b29",
                "0x1026cd56e6f5f2cdba21db405a57b96feb2e36350bba4d0517694362c6493aa7",
                "0x2393e27af789d8eaa209eab81a6263bf0e77cec2d2f538280afb790a7c7a3b79",
                "0xe491c3439f2bc49eb9d3839caf1bcd3a7787e12cd842d06d6d6a61ac87fee306",
                "0xfb8eb52e47d22d85756dcfd06f23ffebc029889b830c1e32eb6ca0e2a0ccd7c0",
                "0x727390a218a6866d084aa300464eb6f3b3d70c8adb2a835383f0d10336447f93",
                "0xf3755bbb4f28248e2906869991a70650c1c01498c446571f16345b13a9291876"
            ]
            let privateKey = try sut.generateExternalPrivateKey(at: UInt32(i))
            XCTAssertEqual(privateKey.data.toHexString().withHexPrefix, expect[i])
        }
    }

    func test_public_key_accounts() throws {
        self.sut = try EthereumMnemonic(bytes: seedBytes)
        for i in 0..<10 {
            let expect = [
                "0x034a76ce52484736497d1bcdd112469043b6bf0a7a1b05ad25a9ff7d145834b39e",
                "0x03766b6fd49286d1fa99fc956ca9da847192d4bd5bdf63adc5e237e12f4223cecd",
                "0x0237a162680c3b1b106d4a9cb95ee0c15bbf2bc2949764bd7be6790e51ba8bf9ed",
                "0x034d7a480f1b97d4e2577021924f54c0be066c690ab843585aa730aece8589246a",
                "0x032a5133c8e733830ceff37dc440ae7b54cbbf3df37f816ec9e7b76d73cfb6e5ed",
                "0x03421442e595e9d2b4c3b8f74fedb02b53dbd9f03b18f1fad0481859cd02acbd1b",
                "0x039027c8f3b22b5a3cfd25bd8d2ed4aa191e24b0e966af5c05399ce318acf24bd4",
                "0x03789a405d2f8ac1cd5f5cbe9e6b0753d85b3ac691fac787416cd28e0de2ec2233",
                "0x029c6d5bc55ff0c61b9c5af4f16f438e44bc5c0af237ba6b44a3f0f3f5688da781",
                "0x03e80063256ecba0015d77a6c1a3c013ee4981ca25e82b7a5c45c2a0a48b0381f4"
            ]
            let privateKey = try sut.generateExternalPrivateKey(at: UInt32(i))
            let publicKey = try privateKey.publicKey(compressed: true)
            XCTAssertEqual(publicKey.data.toHexString().withHexPrefix, expect[i])
        }
    }

    func test_address_accounts() throws {
        self.sut = try EthereumMnemonic(bytes: seedBytes)
        for i in 0..<10 {
            let expect = [
                "0xC8f4D897cfE4a24A715268905aA731D3134f8e8f",
                "0x2dfa91Fcc9A5f1D0B454dAfc6069e3EE1Bcba1c4",
                "0xD11bCCd97Aa8D85E4139f42c958c984cf7dA7B6e",
                "0x202a5e8B90aa3c0490123410DEC6dFf7a4B275E6",
                "0x5c93D116A6a9bb277A3b9Fc157B652350fF6cf97",
                "0x8735C2Ec5341A4F70EC95082e8D58C9046FB3D39",
                "0xb4fc591ed6cC9818DFD845b9B7B68c45d148B672",
                "0xCb7F767857e9aACd1ab8CdAE1bB43ea238a28033",
                "0x0C555840E840D2C2C8B98D6A9d2b212DE349520b",
                "0x1F67EE3Aa0c3e4AAF6530Dcbd834E4227173041c"
            ]
            let privateKey = try sut.generateExternalPrivateKey(at: UInt32(i))
            let publicKey = try privateKey.publicKey(compressed: false)
            let address = try EthereumAddress(publicKey: publicKey)
            XCTAssertEqual(address.eip55Description, expect[i])
        }
    }
}
