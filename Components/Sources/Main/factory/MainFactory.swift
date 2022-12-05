import Foundation
import UIKit
import SwiftUI
import Commons

public struct MainFactory {
    public static func retrieve() -> UIViewController {
        return UIHostingController(rootView: MainView())
    }
}
