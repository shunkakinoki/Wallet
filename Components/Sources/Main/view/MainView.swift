import Home
import SwiftUI
import Transaction

struct MainView: View {
  @State var tabSelection = 0

  @ViewBuilder
  func fetchHomeView() -> some View {
    return HomeFactory.view()
  }

  @ViewBuilder
  func fetchTransactionView() -> some View {
    return TransactionFactory.view()
  }

  var body: some View {
    TabView(selection: $tabSelection) {
      fetchHomeView()
        .tag(0)
        .tabItem {
          Label("Home", systemImage: "house.fill")
        }

      // fetchTransactionView()
      //   .tag(1)
      //   .tabItem {
      //     Label("Explore", systemImage: "safari")
      //   }

      fetchTransactionView()
        .tag(1)
        .tabItem {
          Label("Transactions", systemImage: "mail.stack.fill")
        }
    }
  }
}
