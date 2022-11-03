import Foundation

public extension Data {
    var json: [AnyHashable: Any]? {
        if let dict = try? JSONSerialization.jsonObject(with: self, options: []) as? [AnyHashable: Any] {
            return dict
        } else {
            return nil
        }
    }
}
