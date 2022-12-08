import Foundation

extension Dictionary where Value: Equatable {
  public func containsValue(value: Value) -> Bool {
    return self.contains { $0.1 == value }
  }
}
