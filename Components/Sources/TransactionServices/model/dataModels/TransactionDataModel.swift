import Foundation

struct TransactionDataModel: Decodable {

  public let address: String
  public let transactions: [Transaction]
  public let endingAt: String

  public struct Transaction: Decodable {
    public let address: String
    public let timestamp: Date
    public let txHash: String
    public let fee: Fee
    public let interactedWith: InteractedWith
    public let action: ActionClass
    public let blockchain: Blockchain
    public let assetsSent: [Assets]?
    public let metadata: Metadata
    public let successful: Bool?
    public let assetsReceived: [Assets]?

    public struct ActionClass: Decodable {
      public let verb: Verb?
      public let object: Object?
    }

    public enum Object: Decodable {
      case address
      case contract
      case eth
      case matic
      case objectContract
      case objectEth
    }

    public enum Verb: Decodable {
      case approve
      case bribe
      case burn
      case buy
      case cancel
      case claim
      case create
      case deposit
      case donate
      case execute
      case mint
      case receive
      case sell
      case send
      case stake
      case swap
      case vest
      case vote
      case withdraw
    }

    public struct Assets: Decodable {
      public let from: String
      public let to: String
      public let amount: Double
      public let action: ActionEnum
      public let asset: Asset
    }

    public enum ActionEnum: Decodable {
      case mint
      case transfer
    }

    public struct Asset: Decodable {
      public let address, tokenID: String?
      public let name: String
      public let symbol: String?
      public let standard: Standard
      public let type: AssetType
    }

    public enum Standard: Decodable {
      case contract
      case erc20
      case erc721
      case nativeToken
    }

    public enum AssetType: Decodable {
      case nativeToken
      case nft
      case token
    }

    public enum Blockchain: Decodable {
      case ethereum
      case optimism
      case polygon
    }

    public struct Fee: Decodable {
      public let amount: Double?
      public let currency: Object
    }

    public struct InteractedWith: Decodable {
      public let name: String?
      public let type: InteractedWithType
      public let address: String
    }

    public enum InteractedWithType: Decodable {
      case contractDeployment
      case genericContract
      case safe
      case user
      case community
      case derivatives
      case exchange
      case lending
      case marketplace
      case native
      case nft
      case savings
      case token
      case wallet
    }

    public struct Metadata: Decodable {
      public let successful: Bool?
      public let method: Method?
      public let to: String?
      public let value: String?
    }

    public struct Method: Decodable {
      public let methodID: String
      public let methodName: String?
      public let params: Params?
    }

    public struct Params: Decodable {
      public let req, signature, mastercopy, initializer: String?
      public let saltNonce: Int?
    }
  }

}
