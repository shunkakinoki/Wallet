import Commons
import Home
import SDWebImageSwiftUI
import SwiftUI
import TransactionServices
import UIComponents

public struct TransactionView: View {
  @ObservedObject
  var viewModel: TransactionViewModel

  @Environment(\.presentationMode)
  var presentationMode

  @State
  private var visibleAccount = false

  public init(
    viewModel: TransactionViewModel
  ) {
    self.viewModel = viewModel
  }
  public var body: some View {
    ScrollView(.vertical, showsIndicators: false) {
      VStack {
        HStack(alignment: .center) {
          walletSelectorButton
          Spacer()
        }
        if viewModel.transactions.count > 0 {
          VStack(spacing: 0) {
            ForEach(viewModel.transactions) { asset in
              TransactionItem(transaction: asset)
                .frame(height: 64.5)
              Rectangle()
                .fill(.white.opacity(0.12))
                .frame(height: 0.5)
            }
            .background(Color(Colors.Background.secondary))
          }
          .clipShape(RoundedRectangle(cornerRadius: 8))
          .padding(.top, 15)
        }
      }
      .onAppear {
        viewModel.getWalletSelected()
      }
      .padding([.leading, .trailing, .top], 16)
    }
    .background(Color(Colors.Background.secondary))
  }

  var walletSelectorButton: some View {
    Button(action: { visibleAccount.toggle() }) {
      WalletSelectorIcon(
        walletColor: viewModel.color)
    }
    .sheet(isPresented: $visibleAccount, onDismiss: onDismiss) {
      ProfileSelectorView()
    }
  }

  private func onDismiss() {
    viewModel.getWalletSelected()
  }
}
