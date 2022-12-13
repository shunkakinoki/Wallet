import Foundation

public protocol WriterDirectory {
  func retrieve<T: Codable>(objectType: T.Type, at file: String) throws -> [T?]
  func write<T: Codable>(_ wallet: T, at file: String) throws
  func delete(at file: String) throws
  func deleteAll() throws
}
