import Commons
import Foundation
import SwiftUI

public struct Shimmer: ViewModifier {
  public func body(content: Content) -> some View {
    content
      .mask(ShimmerView())
  }

  struct ShimmerView: View {
    @State private var opacity: Double = 0.25

    public init() {}

    public var body: some View {
      RoundedRectangle(cornerRadius: 2.0)
        .fill(
          LinearGradient(
            gradient: Gradient(stops: [
              .init(color: .black, location: 0),
              .init(color: .white, location: 0.3),
              .init(color: .black, location: 1),
            ]),
            startPoint: .topLeading,
            endPoint: .bottomTrailing)
        )
        .opacity(opacity)
        .transition(.opacity)
        .blendMode(.screen)
        .onAppear {
          let baseAnimation = Animation.easeInOut(duration: 0.8)
          let repeated = baseAnimation.repeatForever(autoreverses: true)
          withAnimation(repeated) {
            self.opacity = 1.0
          }
        }
    }
  }
}

extension View {
  @ViewBuilder public func shimmer(active: Bool = true) -> some View {
    if active {
      modifier(Shimmer())
    } else {
      self
    }
  }
}
