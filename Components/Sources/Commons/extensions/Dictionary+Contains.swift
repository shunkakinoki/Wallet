import Foundation

public extension Dictionary where Value: Equatable {
    func containsValue(value: Value) -> Bool {
        return self.contains { $0.1 == value }
    }
}
