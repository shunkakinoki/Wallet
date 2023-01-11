import Foundation

public enum Constants {
  public static let APP_GROUP_IDENTIFIER: String =
    Bundle.main.object(forInfoDictionaryKey: "APP_GROUP_IDENTIFIER") as? String ?? ""
  public static let NEXT_PUBLIC_ZERION_API_KEY: String =
    Bundle.main.object(forInfoDictionaryKey: "NEXT_PUBLIC_ZERION_API_KEY") as? String ?? ""
  public static let ZERO_WALLET_ADDRESS = "0x0000000000000000000000000000000000000000"
  public static let DEFAULT_NAME = "My Wallet"
}
