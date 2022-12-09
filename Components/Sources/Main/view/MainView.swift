import Home
import SwiftUI
import Transactions

struct MainView: View {
  @State var tabSelection = 1

  @ViewBuilder
  func fetchHomeView() -> some View {
    return HomeFactory.view()
  }

  @ViewBuilder
  func fetchTransactionsView() -> some View {
    return TokensFactory.view()
  }

  var body: some View {
    TabView(selection: $tabSelection) {
      fetchHomeView()
        .tag(0)
        .tabItem {
          Label("Home", systemImage: "house.fill")
        }

      fetchTransactionsView()
        .tag(1)
        .tabItem {
          Label("Explore", systemImage: "safari")
        }
    }
  }
}
