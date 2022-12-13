import Foundation
import SwiftUI
import UIKit

public struct TransactionFactory {
  public static func retrieve() -> UIViewController {
    let vm = TransactionViewModel()
    let view = UIHostingController(rootView: TransactionView())
    return UINavigationController(
      rootViewController: view
    )
  }
}
