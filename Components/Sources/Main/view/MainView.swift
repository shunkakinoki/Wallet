import Home
import Settings
import SwiftUI
import Transaction

struct MainView: View {
  @State var tabSelection = 0

  var body: some View {
    TabView(selection: $tabSelection) {
      HomeView()
        .tag(0)
        .tabItem {
          Label("Home", systemImage: "house.fill")
        }

      // fetchTransactionView()
      //   .tag(1)
      //   .tabItem {
      //     Label("Explore", systemImage: "safari")
      //   }

      TransactionView()
        .tag(1)
        .tabItem {
          Label("Transactions", systemImage: "mail.stack.fill")
        }

    }
  }
}
