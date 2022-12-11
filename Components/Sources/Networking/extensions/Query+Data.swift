import Foundation

extension Query {
  public func toData() -> Data {
    var data = Data()
    do {
      data = try JSONSerialization.data(
        withJSONObject: self.toDictionary(), options: .prettyPrinted)
    } catch {
      data = Data()
    }
    return data
  }
}

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
