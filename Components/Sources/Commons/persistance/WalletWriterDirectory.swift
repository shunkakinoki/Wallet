import Foundation

public struct DirectoryWalletWriterDirectory: WriterDirectory {
  private let fileSubfolder: String
  private let fileManager: FileManager

  enum Error: Swift.Error {
    case errorDecoding
  }

  private var directoryPathSubfolder: String {
    NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
  }

  private var destination: URL {
    fileManager.containerURL(forSecurityApplicationGroupIdentifier: "group.io.magic.light.dev")!
      .appendingPathComponent("keystore")
  }

  public init(fileSubfolder: String) {
    self.fileSubfolder = fileSubfolder
    self.fileManager = FileManager.default
  }

  public func retrieve<T: Codable>(objectType: T.Type, at file: String) throws -> [T?] {
    try fileManager.createDirectory(at: destination, withIntermediateDirectories: true)
    let walletsUrl = try fileManager.contentsOfDirectory(
      at: destination,
      includingPropertiesForKeys: [],
      options: .skipsHiddenFiles
    )
    var wallets: [T?] = []
    do {
      for url in walletsUrl {
        let data = try Data(contentsOf: url)
        let wallet = try? JSONDecoder().decode(objectType, from: data)
        wallets.append(wallet)
      }
    } catch {
      throw Error.errorDecoding
    }
    return wallets
  }

  public func write<T: Codable>(_ wallet: T, at file: String) throws {
    try fileManager.createDirectory(at: destination, withIntermediateDirectories: true)
    let json = try JSONEncoder().encode(wallet)
    try? json.write(to: saveAt(file), options: [.atomic])
  }

  public func delete(at file: String) throws {
    try fileManager.removeItem(at: saveAt(file))
  }

  public func deleteAll() throws {
    let files = try fileManager.contentsOfDirectory(
      at: destination, includingPropertiesForKeys: nil)
    for file in files {
      try fileManager.removeItem(at: file)
    }
  }
}

extension DirectoryWalletWriterDirectory {
  private func saveAt(_ file: String) -> URL {
    destination.appendingPathComponent(file)
  }
}
