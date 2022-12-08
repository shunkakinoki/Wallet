import Commons
import Foundation
import SwiftUI

extension Image {
  public func tabBar() -> some View {
    self
      .resizable()
      .frame(width: 20, height: 20)
      .foregroundColor(Color(Colors.Label.primary))
      .padding(8)
      .background(Color(Colors.Surface.overlay))
      .clipShape(Circle())
  }
}
