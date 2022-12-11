import Commons
import Main
import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

  var window: UIWindow?
  private var coordinator: MainCoordinator?

  func scene(
    _ scene: UIScene,
    willConnectTo session: UISceneSession,
    options connectionOptions: UIScene.ConnectionOptions
  ) {
    guard let windowScene = (scene as? UIWindowScene) else { return }
    let appWindow = UIWindow(frame: windowScene.coordinateSpace.bounds)
    appWindow.windowScene = windowScene
    self.window = appWindow
    self.window?.overrideUserInterfaceStyle = AppTheme.isDarkMode().userInterfaceStyle

    coordinator = MainCoordinator(appWindow)
    coordinator?.start()

    FontLoader.loadAllAvailableFontsIfNeeded()

    NotificationCenter.default.addObserver(
      self,
      selector: #selector(lightMode),
      name: .changeLightTheme,
      object: nil
    )
    NotificationCenter.default.addObserver(
      self,
      selector: #selector(darkMode),
      name: .changeDarkTheme,
      object: nil
    )
  }

  @objc func lightMode() {
    self.window?.overrideUserInterfaceStyle = .light
  }

  @objc func darkMode() {
    self.window?.overrideUserInterfaceStyle = .dark
  }
}
