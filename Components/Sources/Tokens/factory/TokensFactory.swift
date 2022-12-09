import Foundation
import SwiftUI
import UIKit

public struct TokensFactory {
  public static func retrieve() -> UIViewController {
    let vm = TokensViewModel()
    let view = UIHostingController(rootView: TokensView(viewModel: vm))
    vm.closeAction = { [weak view] in
      view?.dismiss(animated: true)
    }
    return UINavigationController(
      rootViewController: view
    )
  }

  public static func view() -> some View {
    return HomeView()
  }
}
