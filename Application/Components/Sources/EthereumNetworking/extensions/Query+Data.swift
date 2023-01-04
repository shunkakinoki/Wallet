import Foundation

extension Dictionary {
  public func toData() -> Data {
    var data = Data()
    do {
      data = try JSONSerialization.data(withJSONObject: self, options: .prettyPrinted)
    } catch {
      data = Data()
    }
    return data
  }
}
