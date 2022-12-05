import Foundation
import UIKit
import SwiftUI

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
