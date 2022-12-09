import Foundation
import SwiftUI

public struct ModalPresenter<Content> : View where Content : View {
  @ViewBuilder public var content: Content

  @Environment(\.presentationMode)
  var presentationMode

  public init(@ViewBuilder content: () -> Content) {
    self.content = content()
  }

  public var body: some View {
    NavigationView {
      ScrollView {
        content
          .padding(.horizontal, 15)
      }
      .navigationBarTitle("More", displayMode: .inline)
      .toolbar { CloseToolbar { presentationMode.wrappedValue.dismiss() } }
    }
  }
}
