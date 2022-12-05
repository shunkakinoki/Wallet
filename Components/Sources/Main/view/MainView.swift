import SwiftUI
import Home

struct MainView: View {

    @ViewBuilder
    func fetchHomeView() -> some View {
        return HomeFactory.view()
    }

    var body: some View {
        TabView {
            NavigationView {
                fetchHomeView()
            }
            .tag(0)
            .tabItem {
                Label("Home", systemImage: "house.fill")
            }
            
            NavigationView {
                fetchHomeView()
            }
            .tag(1)
            .tabItem {
                Label("Explore", systemImage: "safari")
            }
            
            NavigationView {
                fetchHomeView()
            }
            .tag(2)
            .tabItem {
                Label("Transactions", systemImage: "mail.stack.fill")
            }
        }
    }
}
