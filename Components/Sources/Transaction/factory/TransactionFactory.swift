import Foundation
import SwiftUI
import UIKit

public struct TransactionFactory {
  public static func retrieve() -> UIViewController {
    let vm = TransactionViewModel()
    let view = UIHostingController(rootView: TransactionView())
    vm.closeAction = { [weak view] in
      view?.dismiss(animated: true)
    }
    return UINavigationController(
      rootViewController: view
    )
  }
}
