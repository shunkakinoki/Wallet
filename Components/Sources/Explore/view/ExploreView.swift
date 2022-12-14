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
        Text(viewModel.dapps.isEmpty ? "empty" : viewModel.dapps[0].site)
        VStack {
          appsList(dapps: viewModel.dapps)
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
  func appsList(dapps: [Dapp]) -> some View {
    ScrollView(.horizontal, showsIndicators: false) {
      LazyHStack(spacing: 15) {
        ForEach(viewModel.dapps, id: \.self) { item in
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
    }
  }
}
