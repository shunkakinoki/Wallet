import Home
import SwiftUI

struct MainView: View {
  @State var tabSelection = 1

  @ViewBuilder
  func fetchHomeView() -> some View {
    return HomeFactory.view()
  }

  var body: some View {
    TabView(selection: $tabSelection) {
      fetchHomeView()
        .tag(0)
        .tabItem {
          Label("Home", systemImage: "house.fill")
        }

      fetchHomeView()
        .tag(1)
        .tabItem {
          Label("Explore", systemImage: "safari")
        }

      fetchHomeView()
        .tag(2)
        .tabItem {
          Label("Transactions", systemImage: "mail.stack.fill")
        }
    }
  }
}
