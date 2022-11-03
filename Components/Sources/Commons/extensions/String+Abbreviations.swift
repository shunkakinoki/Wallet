import Foundation

public extension String {
    func addressFormat() -> String {
        return [self.prefix(8), self.suffix(6)].joined(separator: "...")
    }
}
