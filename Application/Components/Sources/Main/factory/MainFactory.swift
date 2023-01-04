import Commons
import Foundation
import SwiftUI
import UIKit

public struct MainFactory {
  public static func retrieve() -> UIViewController {
    return UIHostingController(rootView: MainView())
  }
}
