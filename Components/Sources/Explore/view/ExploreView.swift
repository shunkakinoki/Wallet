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
          Group {
            HStack {
              Text("Bridge")
                .font(.system(size: 24, weight: .semibold))
                .foregroundColor(Color(Colors.Label.primary))
              Spacer()
            }
            .padding([.leading, .trailing], 23)
            .padding([.top], 25)

            HStack {
              Text("Move assets between different layers of Ethereum by bridging them across.")
                .font(.system(size: 16, weight: .semibold))
                .foregroundColor(Color(Colors.Label.secondary))
              Spacer()
            }
            .padding([.leading, .trailing], 23)
            .padding([.top], 3)

            ScrollView(.horizontal, showsIndicators: false) {
              LazyHStack(spacing: 15) {
                ForEach(
                  Array(
                    viewModel.dapps.isEmpty ? [] : viewModel.dapps.filter { $0.type == "bridge" }),
                  id: \.self
                ) {
                  item in
                  appLink(item: item)
                }
              }
            }.padding([.top], 2)
          }

          Group {
            HStack {
              Text("Mint")
                .font(.system(size: 24, weight: .semibold))
                .foregroundColor(Color(Colors.Label.primary))
              Spacer()
            }
            .padding([.leading, .trailing], 23)
            .padding([.top], 25)

            HStack {
              Text("Find new art, music & cultural objects to mint into existence.")
                .font(.system(size: 16, weight: .semibold))
                .foregroundColor(Color(Colors.Label.secondary))
              Spacer()
            }
            .padding([.leading, .trailing], 23)
            .padding([.top], 3)

            ScrollView(.horizontal, showsIndicators: false) {
              LazyHStack(spacing: 15) {
                ForEach(
                  Array(
                    viewModel.dapps.isEmpty ? [] : viewModel.dapps.filter { $0.type == "mint" }),
                  id: \.self
                ) {
                  item in
                  appLink(item: item)
                }
              }
            }
          }

          Group {
            HStack {
              Text("NFT Marketplace")
                .font(.system(size: 24, weight: .semibold))
                .foregroundColor(Color(Colors.Label.primary))
              Spacer()
            }
            .padding([.leading, .trailing], 23)
            .padding([.top], 25)

            HStack {
              Text(
                "Place bids on existing NFTs that you want to buy."
              )
              .font(.system(size: 16, weight: .semibold))
              .foregroundColor(Color(Colors.Label.secondary))
              Spacer()
            }
            .padding([.leading, .trailing], 23)
            .padding([.top], 3)

            ScrollView(.horizontal, showsIndicators: false) {
              LazyHStack(spacing: 15) {
                ForEach(
                  Array(viewModel.dapps.isEmpty ? [] : viewModel.dapps.filter { $0.type == "nft" }),
                  id: \.self
                ) {
                  item in
                  appLink(item: item)
                }
              }
            }
          }

          Group {
            HStack {
              Text("Swap")
                .font(.system(size: 24, weight: .semibold))
                .foregroundColor(Color(Colors.Label.primary))
              Spacer()
            }
            .padding([.leading, .trailing], 23)
            .padding([.top], 25)

            HStack {
              Text(
                "Swap tokens on Ethereum & other networks using decentralized exchanges, which are known as DEXs."
              )
              .font(.system(size: 16, weight: .semibold))
              .foregroundColor(Color(Colors.Label.secondary))
              Spacer()
            }
            .padding([.leading, .trailing], 23)
            .padding([.top], 3)

            ScrollView(.horizontal, showsIndicators: false) {
              LazyHStack(spacing: 15) {
                ForEach(
                  Array(
                    viewModel.dapps.isEmpty ? [] : viewModel.dapps.filter { $0.type == "swap" }),
                  id: \.self
                ) {
                  item in
                  appLink(item: item)
                }
              }
            }
          }
          .padding([.bottom], 13)

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
