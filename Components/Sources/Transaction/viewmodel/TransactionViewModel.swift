import Combine
import Foundation
import TransactionServices

public final class TransactionViewModel: ObservableObject {
  @Published var tokens = [Token]()
  private var subscriptions = Set<AnyCancellable>()
  var closeAction: () -> Void = {}

  public init(GetTransactions: GetTransactions = GetTransactionsImp()) {
    GetTransactions.invoke()
      .receive(on: DispatchQueue.main)
      .sink(
        receiveCompletion: { error in
          print(error)
        },
        receiveValue: { value in
          self.tokens = value
        }
      )
      .store(in: &subscriptions)
  }
}

extension Optional where Wrapped: Combine.Publisher {
  func orEmpty() -> AnyPublisher<Wrapped.Output, Wrapped.Failure> {
    self?.eraseToAnyPublisher() ?? Empty().eraseToAnyPublisher()
  }
}
