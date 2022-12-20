import Explore
import Home
import Settings
import SwiftUI
import Transaction

struct MainView: View {
  @AppStorage("selectedTab") var tabSelection = 0

  var body: some View {
    TabView(selection: $tabSelection) {
      HomeView()
        .tag(0)
        .tabItem {
          Label("", systemImage: "house.fill")
        }

      ExploreView()
        .tag(1)
        .tabItem {
          Label("", systemImage: "safari")
        }

      TransactionView()
        .tag(2)
        .tabItem {
          Label("", systemImage: "mail.stack.fill")
        }

    }
  }
}
