import Foundation

public enum Constants {
  public static let APP_ACCESS_GROUP: String = "4Z47XRX22C.io.magic.light"
  public static let APP_GROUP_IDENTIFIER: String =
    Constants.CF_BUNDLE_NAME == "Light"
    ? "group.io.magic.light" : "group.io.magic.light"
  public static let CF_BUNDLE_NAME: String =
    Bundle.main.infoDictionary?["CFBundleName"] as? String ?? ""
  public static let NEXT_PUBLIC_ZERION_API_KEY: String =
    Bundle.main.object(forInfoDictionaryKey: "NEXT_PUBLIC_ZERION_API_KEY") as? String ?? ""
  public static let ZERO_WALLET_ADDRESS = "0x0000000000000000000000000000000000000000"
  public static let DEFAULT_NAME = "My Wallet"

}
