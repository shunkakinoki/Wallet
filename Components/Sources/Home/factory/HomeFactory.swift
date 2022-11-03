import Foundation
import UIKit
import SwiftUI
import Commons

public struct HomeFactory {
    public static func retrieve() -> UIViewController {
        return UIHostingController(rootView: HomeView())
    }
}
