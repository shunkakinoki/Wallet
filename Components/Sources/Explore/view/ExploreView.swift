import Commons
import SDWebImageSwiftUI
import SPIndicator
import SwiftUI
import UIComponents

public struct ExploreView: View {
  @ObservedObject
  var viewModel: ExploreViewModel = ExploreViewModel()

  @State
  private var showAppsDetail = false

  public init() {}

  public var body: some View {
    NavigationView {
      ScrollView {
        VStack {
          appsList()
        }
        .onAppear {
          viewModel.getConfiguration()
        }
        .onReceive(
          NotificationCenter.default.publisher(for: UIApplication.willEnterForegroundNotification)
        ) { _ in
          viewModel.getConfiguration()
        }
        .sheet(isPresented: $showAppsDetail) {
          appsDetail
        }
        .padding([.leading, .trailing], 16)
        .padding([.top], 8)
        Spacer()
      }
      .navigationTitle("Explore Dapps")
    }
  }

  var appsDetail: some View {
    ModalPresenter {
      appsList(isDetail: true)
        .navigationBarTitle("Dapps", displayMode: .inline)
    }
  }

  private func onDismiss() {
    viewModel.getConfiguration()
    viewModel.isLoading = true
  }
}

extension ExploreView {
  func appsList(isDetail: Bool = false) -> some View {
    VStack {
      if !isDetail {
        HStack {
          Text("Dapps")
            .font(.system(size: 15, weight: .semibold))
            .foregroundColor(Color(Colors.Label.secondary))
            .padding(.top, 16)
            .opacity(viewModel.configurations.count == 0 ? 0 : 1)
          Spacer()
          Button {
            showAppsDetail.toggle()
          } label: {
            Text("More")
              .font(.system(size: 15, weight: .semibold))
              .foregroundColor(Color(Colors.Label.secondary))
              .padding(.top, 16)
              .opacity(viewModel.configurations.count == 0 ? 0 : 1)
          }
        }
      }
      VStack(spacing: 0) {
        ForEach(
          isDetail == true ? viewModel.configurations : Array(viewModel.configurations.prefix(10)),
          id: \.self
        ) { configuration in
          Link(destination: URL(string: "https://\(configuration.host)")!) {
            HStack {
              WebImage(
                url: URL(
                  string:
                    "https://\(configuration.host)/\(configuration.favicon ?? "favicon.ico")")
              )
              .resizable()
              .frame(width: 36, height: 36)
              .clipShape(RoundedRectangle(cornerRadius: 8))
              VStack(alignment: .leading, spacing: 0) {
                Text(configuration.host)
                  .foregroundColor(Color(Colors.Label.primary))
                  .font(Font.system(size: 17, weight: .regular))
                  ._lineHeightMultiple(1.09)
                Text(configuration.host)
                  .foregroundColor(Color(Colors.Label.secondary))
                  .font(Font.system(size: 12, weight: .regular))
                  ._lineHeightMultiple(1.12)
              }
              .padding([.bottom], 2)
              Spacer()
              Image(viewModel.getChainImage(chainId: configuration.chainId))
                .frame(width: 24, height: 24)
                .padding(.trailing, 24)
                .foregroundColor(Color(Colors.System.red))
            }
            .contentShape(Rectangle())
            .frame(maxWidth: .infinity)
            .padding([.top, .bottom], 8).padding(.leading, 16)
          }
          if configuration != viewModel.configurations.last {
            Rectangle()
              .fill(Color(Colors.Separator.transparency))
              .frame(height: 0.5)
              .padding(.leading, 54)
          }
        }
      }
      .background(Color(Colors.System.secondary))
      .cornerRadius(14)
      .padding(.top, 6)
      .padding(.bottom, 16)
    }
  }
}
