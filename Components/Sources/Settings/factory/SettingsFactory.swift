import Foundation
import UIKit
import Session
import SwiftUI

public struct SettingsFactory {
    public static func retrieve() -> UIViewController {
        return UINavigationController(
            rootViewController: UIHostingController(
                rootView: SettingsView()
            )
        )
    }
}
