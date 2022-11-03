import Foundation
import UIKit

public struct OnboardingFactory {
    public static func retrieve() -> UIViewController {
        return OnboardingView()
    }
}
