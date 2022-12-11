import Foundation
import UIKit

extension UserDefaults {
  func valueExists(forKey key: String) -> Any? {
    return object(forKey: key)
  }
}

public enum Theme: Int {
  case device
  case light
  case dark
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
  public static func isDarkMode() -> Theme {
    if let value = UserDefaults.standard.valueExists(forKey: "AppTheme"),
      let appTheme = value as? String
    {
      switch appTheme
      {
      case "dark":
        return .dark
      case "light":
        return .light
      case "device":
        return .device
      default:
        return .device
      }
    }
    return .device
  }
}
