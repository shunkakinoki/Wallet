import Combine
import Foundation
import Session
import TransactionServices

public final class TransactionViewModel: ObservableObject {
  private let selectedWallet: SelectedWallet

  @Published var transactions = [TransactionStruct]()
  private var subscriptions = Set<AnyCancellable>()
  var closeAction: () -> Void = {}

  @Published
  var color: String = ""

  public init(
    GetTransactions: GetTransactions = GetTransactionsImp(),
    selectedWallet: SelectedWallet = SelectedWalletImp()
  ) {
    self.selectedWallet = selectedWallet

    GetTransactions.invoke()
      .receive(on: DispatchQueue.main)
      .sink(
        receiveCompletion: { error in
          print(error)
        },
        receiveValue: { value in
          self.transactions = value
        }
      )
      .store(in: &subscriptions)
  }

  public func getWalletSelected() {
    do {
      let walletSelected = try selectedWallet.selected()
      self.color = walletSelected.color.rawValue
    } catch {
      self.color = "pink"
    }
  }

}

extension Optional where Wrapped: Combine.Publisher {
  func orEmpty() -> AnyPublisher<Wrapped.Output, Wrapped.Failure> {
    self?.eraseToAnyPublisher() ?? Empty().eraseToAnyPublisher()
  }
}
