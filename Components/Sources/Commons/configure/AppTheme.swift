import Foundation
import UIKit

extension UserDefaults {
    func valueExists(forKey key: String) -> Any? {
        return object(forKey: key)
    }
}

public struct AppTheme {
    public static func isDarkMode() -> Bool {
        if let value = UserDefaults.standard.valueExists(forKey: "InterfaceDesign"), let bool = value as? Bool {
            return bool
        }
        return true
    }
}
