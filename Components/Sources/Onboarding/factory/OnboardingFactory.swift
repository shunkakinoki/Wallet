import Foundation
import Session
import SwiftUI
import UIKit

public struct OnboardingFactory {
  public static func retrieve() -> UIViewController {
    return UINavigationController(
      rootViewController: UIHostingController(
        rootView: OnboardingView()
      )
    )
  }
}
