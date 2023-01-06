import Foundation
import SwiftUI
import UIKit

public struct ExploreFactory {
  public static func retrieve() -> UIViewController {
    return UINavigationController(
      rootViewController: UIHostingController(
        rootView: ExploreView()
      )
    )
  }
}
