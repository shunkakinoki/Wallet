import Foundation

extension String {
  public func addressFormat() -> String {
    return [self.prefix(8), self.suffix(6)].joined(separator: "...")
  }
}
