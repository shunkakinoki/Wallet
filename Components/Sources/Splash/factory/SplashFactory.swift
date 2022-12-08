import Foundation
import Session
import UIKit

public struct SplashFactory {
  public static func retrieve() -> UIViewController {
    let viewModel = SplashViewModelImp(isSigned: IsSignedImp())
    let view = SplashViewController(viewModel: viewModel)
    return view
  }
}
