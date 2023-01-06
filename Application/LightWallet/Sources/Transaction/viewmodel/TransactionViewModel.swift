import Combine
import Foundation
import Session
import TransactionServices

public final class TransactionViewModel: ObservableObject {
  private let selectedWallet: SelectedWallet
  private let getTransactions: GetTransactions

  @Published var transactions = [TransactionStruct]()
  private var subscriptions = Set<AnyCancellable>()

  @Published
  var color: String = ""

  public init(
    GetTransactions: GetTransactions = GetTransactionsImp(),
    selectedWallet: SelectedWallet = SelectedWalletImp()
  ) {
    self.getTransactions = GetTransactionsImp()
    self.selectedWallet = selectedWallet
    self.retrieve()
  }

  public func getWalletSelected() {
    do {
      let walletSelected = try selectedWallet.selected()
      self.color = walletSelected.color.rawValue
    } catch {
      self.color = "pink"
    }
  }

  public func retrieve() {
    getTransactions.invoke()
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

  public func refresh() {
    self.transactions = []
    self.retrieve()
  }
}
