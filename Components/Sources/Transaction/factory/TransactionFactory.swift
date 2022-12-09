import Foundation
import SwiftUI
import UIKit

public struct TransactionFactory {
  public static func retrieve() -> UIViewController {
    let vm = TransactionViewModel()
    let view = UIHostingController(rootView: TransactionView(viewModel: vm))
    vm.closeAction = { [weak view] in
      view?.dismiss(animated: true)
    }
    return UINavigationController(
      rootViewController: view
    )
  }

  public static func view() -> some View {
    let vm = TransactionViewModel()
    return TransactionView(viewModel: vm)
  }
}
