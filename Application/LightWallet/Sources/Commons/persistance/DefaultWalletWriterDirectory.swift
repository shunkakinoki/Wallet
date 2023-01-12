import Foundation

public struct UserDefaultsWalletWriterDirectory: WriterDirectory {

  enum Error: Swift.Error {
    case writing
    case deleting
    case retrieving
  }

  public init() {}

  public func retrieve<T>(objectType: T.Type, at file: String) throws -> [T?]
  where T: Decodable, T: Encodable {
    guard
      let sharedContainer = UserDefaults(
        suiteName: Constants.CF_BUNDLE_NAME == "Light"
          ? "group.io.magic.light"
          : Constants.CF_BUNDLE_NAME == "Light"
            ? "group.io.magic.light" : "group.io.magic.light.dev"
      ),
      let wallet = try sharedContainer.get(objectType: objectType.self, forKey: file)
    else {
      throw Error.retrieving
    }
    return [wallet]
  }

  public func write<T>(_ wallet: T, at file: String) throws where T: Decodable, T: Encodable {
    guard
      let sharedContainer = UserDefaults(
        suiteName: Constants.CF_BUNDLE_NAME == "Light"
          ? "group.io.magic.light" : "group.io.magic.light.dev"
      )
    else {
      throw Error.writing
    }
    try sharedContainer.set(object: wallet, forKey: file)
    sharedContainer.synchronize()
  }

  public func delete(at file: String) throws {
    guard
      let sharedContainer = UserDefaults(
        suiteName: Constants.CF_BUNDLE_NAME == "Light"
          ? "group.io.magic.light" : "group.io.magic.light.dev"
      )
    else {
      throw Error.deleting
    }
    try sharedContainer.remove(forKey: file)
    sharedContainer.synchronize()
  }

  public func deleteAll() throws {
    guard
      let sharedContainer = UserDefaults(
        suiteName: Constants.CF_BUNDLE_NAME == "Light"
          ? "group.io.magic.light" : "group.io.magic.light.dev"
      )
    else {
      throw Error.deleting
    }
    try sharedContainer.removeAll()
    sharedContainer.synchronize()
  }
}
