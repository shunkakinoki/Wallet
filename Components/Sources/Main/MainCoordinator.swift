import Commons
import Foundation
import Home
import Onboarding
import Splash
import UIKit

public final class MainCoordinator {
  private let window: UIWindow

  public init(_ window: UIWindow) {
    self.window = window
    listenNotifications()
  }

  public func start() {
    window.rootViewController = splashComponent()
    window.makeKeyAndVisible()
  }
}

// MARK: - Present components
extension MainCoordinator {
  private func presentLoginComponent(animated: Bool) {
    DispatchQueue.main.async {
      self.transitionToRootViewController(self.onboardingComponent(), animated: animated)
    }
  }

  private func presentMainComponent(animated: Bool) {
    DispatchQueue.main.async {
      self.transitionToRootViewController(self.mainComponent(), animated: animated)
    }
  }
}

// MARK: - Notifications
extension MainCoordinator {
  fileprivate func listenNotifications() {
    NotificationCenter.default.addObserver(
      self,
      selector: #selector(logInCompleted),
      name: .lightLogIn, object: nil
    )
    NotificationCenter.default.addObserver(
      self,
      selector: #selector(logOutCompleted),
      name: .lightLogOut, object: nil
    )
  }
}

extension MainCoordinator {
  private func transitionToRootViewController(
    _ viewController: UIViewController, animated: Bool = true
  ) {
    guard animated else {
      window.rootViewController = viewController
      window.makeKeyAndVisible()
      return
    }
    let snapshot = window.snapshotView(afterScreenUpdates: true)
    if let snapshot = snapshot { viewController.view.addSubview(snapshot) }
    window.rootViewController = viewController

    UIView.animate(
      withDuration: 0.3,
      animations: {
        snapshot?.layer.opacity = 0
        snapshot?.layer.transform = CATransform3DMakeScale(1.5, 1.5, 1.5)
      },
      completion: { _ in
        snapshot?.removeFromSuperview()
      })
  }
}

// MARK: -  Components Actions
extension MainCoordinator {
  @objc func logInCompleted() {
    DispatchQueue.main.async {
      self.presentMainComponent(animated: true)
    }
  }

  @objc func logOutCompleted() {
    presentLoginComponent(animated: true)
  }
}

extension MainCoordinator {
  internal func splashComponent() -> UIViewController {
    return SplashFactory.retrieve()
  }

  internal func mainComponent() -> UIViewController {
    return MainFactory.retrieve()
  }

  private func onboardingComponent() -> UIViewController {
    return OnboardingFactory.retrieve()
  }
}
