import Foundation
import SwiftUI

extension View {
  public func hideKeyboard() {
    UIApplication.shared.sendAction(
      #selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
  }
}
