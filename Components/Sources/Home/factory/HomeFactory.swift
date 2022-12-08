import Foundation
import SwiftUI
import UIKit

public struct HomeFactory {
  public static func retrieve() -> UIViewController {
    return UINavigationController(
      rootViewController: UIHostingController(
        rootView: HomeView()
      )
    )
  }

  public static func view() -> some View {
    return HomeView()
  }
}
