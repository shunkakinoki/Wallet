import Foundation
import UIKit

extension UserDefaults {
  func valueExists(forKey key: String) -> Any? {
    return object(forKey: key)
  }
}

public enum Theme: Int, CaseIterable {
  case device
  case light
  case dark

  public var description: String {
    switch self {
    case .device: return "System"
    case .light: return "Light"
    case .dark: return "Dark"
    }
  }

}

extension Theme {
  public var userInterfaceStyle: UIUserInterfaceStyle {
    switch self {
    case .device:
      return .unspecified
    case .light:
      return .light
    case .dark:
      return .dark
    }
  }
}

public struct AppTheme {
  public static func getThemeString() -> String {
    return self.getTheme().description
  }
  public static func getUserInterfaceStyle() -> UIUserInterfaceStyle {
    return self.getTheme().userInterfaceStyle
  }
  public static func getTheme() -> Theme {
    let rawValue = UserDefaults.standard.integer(forKey: "AppTheme")
    return Theme(rawValue: rawValue) ?? .device
  }
}
