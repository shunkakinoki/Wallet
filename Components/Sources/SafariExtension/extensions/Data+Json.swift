import Foundation

extension Data {
  public var json: [AnyHashable: Any]? {
    if let dict = try? JSONSerialization.jsonObject(with: self, options: []) as? [AnyHashable: Any]
    {
      return dict
    } else {
      return nil
    }
  }
}
