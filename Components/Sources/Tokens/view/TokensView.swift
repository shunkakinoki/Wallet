import Commons
import SDWebImageSwiftUI
import SwiftUI
import TokenServices
import UIComponents

public struct TokensView: View {
  @ObservedObject
  var viewModel: TokensViewModel

  @Environment(\.presentationMode)
  var presentationMode

  public init(viewModel: TokensViewModel) {
    self.viewModel = viewModel
  }
  public var body: some View {
    NavigationView {
      VStack {
        if viewModel.tokens.count > 0 {
          ScrollView(.vertical, showsIndicators: false) {
            VStack(spacing: 0) {
              ForEach(viewModel.tokens) { asset in
                TokenItem(token: asset)
                  .frame(height: 64.5)
                Rectangle()
                  .fill(.white.opacity(0.12))
                  .frame(height: 0.5)
              }
              .background(Color(Colors.Base.background))
            }
            .clipShape(RoundedRectangle(cornerRadius: 8))
            .padding(.top, 15)
          }
          .padding(.horizontal, 10)
        }
      }
      .background(Color(Colors.Base.detailBackground))
      .navigationBarTitle("Tokens", displayMode: .inline)
      .toolbar { CloseToolbar { presentationMode.wrappedValue.dismiss() } }
      Spacer()
    }
  }
}
