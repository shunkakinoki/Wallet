import Foundation
import Session
import SwiftUI
import UIKit

public struct SettingsFactory {
  public static func retrieve() -> UIViewController {
    return UINavigationController(
      rootViewController: UIHostingController(
        rootView: SettingsView()
      )
    )
  }
}
