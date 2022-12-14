import Commons
import DappServices
import SDWebImageSwiftUI
import SPIndicator
import SwiftUI
import UIComponents

public struct ExploreView: View {
  @ObservedObject
  var viewModel: ExploreViewModel = ExploreViewModel()

  public init() {}

  public var body: some View {
    NavigationView {
      ScrollView {
        VStack {
          dappSection(
            dapps: Array(
              viewModel.dapps.isEmpty ? [] : viewModel.dapps.filter { $0.type == "bridge" }),
            title: "Bridge",
            subTitle:
              "Move assets between different layers of Ethereum by bridging them across."
          )

          dappSection(
            dapps: Array(
              viewModel.dapps.isEmpty ? [] : viewModel.dapps.filter { $0.type == "mint" }),
            title: "Mint",
            subTitle:
              "Find new art, music & cultural objects to mint into existence."
          )

          dappSection(
            dapps: Array(
              viewModel.dapps.isEmpty ? [] : viewModel.dapps.filter { $0.type == "nft" }),
            title: "NFT Marketplace",
            subTitle:
              "Place bids on existing NFTs that you want to buy."
          )

          dappSection(
            dapps: Array(
              viewModel.dapps.isEmpty ? [] : viewModel.dapps.filter { $0.type == "swap" }),
            title: "Swap",
            subTitle:
              "Swap tokens on Ethereum & other networks using decentralized exchanges, which are known as DEXs."
          )

          dappSection(
            dapps: Array(
              viewModel.dapps.isEmpty ? [] : viewModel.dapps.filter { $0.type == "social" }),
            title: "Social",
            subTitle:
              "Interact with next-generation of blockchain social apps that assures your data ownership."
          )

          VStack(spacing: 0) {}.padding([.bottom], 30)

        }
        .onAppear {
          viewModel.getConfiguration()
          self.refreshDapps()
        }
        .onReceive(
          NotificationCenter.default.publisher(for: UIApplication.willEnterForegroundNotification)
        ) { _ in
          viewModel.getConfiguration()
        }
        .padding([.top], 8)
        Spacer()
      }
      .refreshable {
        self.refreshDapps()
      }
      .navigationTitle("Explore Dapps")
    }
  }

  private func onDismiss() {
    viewModel.getConfiguration()
    viewModel.isLoading = true
  }

  private func refreshDapps() {
    Task {
      await viewModel.getDapps()
    }
  }
}

extension ExploreView {
  func appLink(item: Dapp) -> some View {
    Link(destination: URL(string: item.site)!) {
      HStack {
        WebImage(
          url: URL(
            string:
              item.icon)
        )
        .resizable()
        .frame(width: 36, height: 36)
        .clipShape(RoundedRectangle(cornerRadius: 8))
        VStack(alignment: .leading, spacing: 0) {
          Text(item.name)
            .foregroundColor(Color(Colors.Label.primary))
            .font(Font.system(size: 17, weight: .regular))
            ._lineHeightMultiple(1.09)
          Text(item.site)
            .foregroundColor(Color(Colors.Label.secondary))
            .font(Font.system(size: 12, weight: .regular))
            ._lineHeightMultiple(1.12)
        }
        .padding([.bottom], 2)
        Spacer()
      }.contentShape(Rectangle())
        .frame(maxWidth: .infinity)
        .padding([.top, .bottom], 8).padding(.leading, 16)
    }.background(Color(Colors.System.secondary))
      .cornerRadius(14)
  }
}

extension ExploreView {
  func dappSection(dapps: [Dapp], title: String, subTitle: String) -> some View {
    Group {
      HStack {
        Text(title)
          .font(.system(size: 24, weight: .semibold))
          .foregroundColor(Color(Colors.Label.primary))
        Spacer()
      }
      .padding([.leading, .trailing], 23)
      .padding([.top], 25)
      .padding([.bottom], 1)

      HStack {
        Text(subTitle)
          .font(.system(size: 14, weight: .semibold))
          .foregroundColor(Color(Colors.Label.secondary))
        Spacer()
      }
      .padding([.leading, .trailing], 23)

      ScrollView(.horizontal, showsIndicators: false) {
        LazyHStack(spacing: 15) {
          ForEach(dapps, id: \.self) { item in appLink(item: item) }
        }
      }
    }

  }
}
