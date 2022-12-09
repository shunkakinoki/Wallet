import Foundation

struct TransactionDataModel: Decodable {

  public let address: String
  public let transactions: [Transaction]
  public let endingAt: String

  public struct Transaction: Decodable {
    public let address: String
    public let timestamp: String
    public let txHash: String
    public let fee: Fee
    public let interactedWith: InteractedWith
    public let action: ActionClass
    public let blockchain: String
    public let assetsSent: [Assets]?
    public let metadata: Metadata
    public let successful: Bool?
    public let assetsReceived: [Assets]?

    public struct Assets: Decodable {
      public let from: String
      public let to: String
      public let amount: Double
      public let action: ActionClass
      public let asset: Asset
    }

    public struct ActionClass: Decodable {
      public let verb: String?
      public let object: String
    }

    public struct Asset: Decodable {
      public let address, tokenID: String?
      public let name: String
      public let symbol: String?
      public let standard: String
      public let type: String
    }

    public struct Fee: Decodable {
      public let amount: Double?
      public let currency: String
    }

    public struct InteractedWith: Decodable {
      public let name: String?
      public let type: String
      public let address: String
    }

    public struct Metadata: Decodable {
      public let successful: Bool?
      public let method: Method?
      public let to: String?
      public let value: String?
    }

    public struct Method: Decodable {
      public let methodID: String?
      public let methodName: String?
      public let params: Params?
    }

    public struct Params: Decodable {
      public let req, signature, mastercopy, initializer: String?
      public let saltNonce: Int?
    }
  }

}
