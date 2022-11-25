import Foundation
import UIKit
import Session
import SwiftUI

public struct OnboardingFactory {
    public static func retrieve() -> UIViewController {
        return UINavigationController(
            rootViewController: UIHostingController(
                rootView: OnboardingView()
            )
        )
    }
}
