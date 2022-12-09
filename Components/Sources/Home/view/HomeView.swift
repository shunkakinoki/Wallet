import AlertToast
import Commons
import SDWebImageSwiftUI
import Settings
import SwiftUI
import UIComponents

struct HomeView: View {
  @ObservedObject
  var viewModel: HomeViewModel = HomeViewModel()

  @State
  private var visibleAccount = false

  @State
  private var showTokensDetail = false

  @State
  private var showAppsDetail = false

  @State
  private var showingMore = false

  @State
  private var showingQR = false

  @State
  private var showToast = false

  @State
  private var showingSettings = false

  var body: some View {
    ScrollView {
      VStack {
        HStack(alignment: .center) {
          walletSelectorButton
          Spacer()
          settingsButton
        }
        HStack(spacing: 24) {
          Button {
            UIPasteboard.general.setValue(
              viewModel.selectedRawAddress,
              forPasteboardType: "public.plain-text"
            )
          } label: {
            VStack {
              Image(systemName: "plus")
                .font(.system(size: 17, weight: .bold))
                .padding([.top, .bottom], 14)
                .foregroundColor(Color(Colors.Label.primary))
                .frame(width: 48, height: 48)
                .background(Color(Colors.Background.secondary))
                .clipShape(Circle())
                .padding(.top, 25)
              Text("Buy")
                .font(.body)
                .foregroundColor(Color(Colors.Label.primary))
            }
          }
          Button {
            showingQR.toggle()
          } label: {
            VStack {
              Image(systemName: "arrow.down")
                .font(.system(size: 17, weight: .bold))
                .padding([.top, .bottom], 14)
                .foregroundColor(Color(Colors.Label.primary))
                .frame(width: 48, height: 48)
                .background(Color(Colors.Background.secondary))
                .clipShape(Circle())
                .padding(.top, 25)
              Text("Receive")
                .font(.body)
                .foregroundColor(Color(Colors.Label.primary))
            }
          }.sheet(isPresented: $showingQR) {
            ShowQR(text: viewModel.selectedRawAddress)
          }
          VStack {
            Menu {
              Button(action: {
                UIPasteboard.general.setValue(
                  viewModel.selectedRawAddress,
                  forPasteboardType: "public.plain-text"
                )
                showToast.toggle()
              }) {
                Label("Copy Address", systemImage: "doc.on.clipboard")
              }
              Button(action: {
                showingQR.toggle()
              }) {
                Label("Show QR Code", systemImage: "qrcode")
              }
            } label: {
              Image(systemName: "ellipsis.circle")
                .font(.system(size: 17, weight: .bold))
                .padding([.top, .bottom], 14)
                .foregroundColor(Color(Colors.Label.primary))
                .frame(width: 48, height: 48)
                .background(Color(Colors.Background.secondary))
                .clipShape(Circle())
                .padding(.top, 25)
            }
            Text("More")
              .font(.body)
              .foregroundColor(Color(Colors.Label.primary))
          }
          Spacer()
        }
        Link(destination: URL(string: "https://wallet.light.so")!) {
          ZStack {
            VStack(alignment: .leading, spacing: 0) {
              HStack(spacing: -6) {
                Image(systemName: "safari.fill")
                  .resizable()
                  .scaledToFit()
                  .padding(6.0)
                  .frame(width: 30, height: 30)
                  .foregroundColor(.blue)
                  .background(.white)
                  .cornerRadius(7.0)
                  .padding([.leading, .top], 16)
                Image(systemName: "puzzlepiece.extension.fill")
                  .resizable()
                  .scaledToFit()
                  .padding(6.0)
                  .frame(width: 30, height: 30)
                  .foregroundColor(.blue)
                  .background(.white)
                  .cornerRadius(7.0)
                  .padding([.leading, .top], 16)
              }
              Text("Set Up Light For Safari")
                .foregroundColor(Color(.white))
                .padding(.leading, 16).padding(.top, 8)
                .font(.system(size: 17, weight: .semibold))
              HStack {
                Text("Set up Light Safari Extension to use Light on any website, right from Safari")
                  .foregroundColor(Color(.white))
                  .padding([.leading, .bottom], 16).padding(.top, 8)
                  .font(.system(size: 13, weight: .regular))
                Spacer()
              }
            }
            .multilineTextAlignment(.leading)
          }
          .contentShape(Rectangle())
          .frame(maxWidth: .infinity)
          .background(Color(.systemBlue))
          .cornerRadius(14)
          .padding(.top, 16)
        }
        tokenList()
        appsList()
        Spacer()
      }
      .onReceive(
        NotificationCenter.default.publisher(for: UIApplication.willEnterForegroundNotification)
      ) { _ in
        viewModel.getConfiguration()
        refreshTokens()
      }
      .onAppear {
        viewModel.getWalletSelected()
        viewModel.getConfiguration()
        refreshTokens()
      }
      .sheet(isPresented: $showTokensDetail) {
        tokenDetail
      }
      .sheet(isPresented: $showAppsDetail) {
        appsDetail
      }
      .padding([.leading, .trailing, .top], 16)
      Spacer()
    }
    .toast(isPresenting: $showToast) {
      AlertToast(type: .complete(Color(.green)), title: "Copied!")
    }
    .refreshable {}
  }

  var tokenDetail: some View {
    ModalPresenter {
      tokenList(isDetail: true)
    }
  }

  var appsDetail: some View {
    ModalPresenter {
      appsList(isDetail: true)
    }
  }

  var walletSelectorButton: some View {
    Button(action: { visibleAccount.toggle() }) {
      WalletSelector(
        walletColor: viewModel.color, walletName: viewModel.name,
        walletAddress: viewModel.selectedAddress)
    }
    .sheet(isPresented: $visibleAccount, onDismiss: onDismiss) {
      ProfileSelectorView()
    }
  }

  var settingsButton: some View {
    Button(action: { showingSettings.toggle() }) {
      Image(systemName: "gearshape.fill")
        .resizable()
        .frame(width: 20, height: 20)
        .foregroundColor(Color(Colors.Label.primary))
        .padding(8)
        .background(Color(Colors.Surface.overlay))
        .clipShape(Circle())
    }
    .sheet(isPresented: $showingSettings, onDismiss: onDismiss) {
      SettingsView()
    }
  }

  private func onDismiss() {
    viewModel.getWalletSelected()
    viewModel.getConfiguration()
    refreshTokens()
  }

  private func refreshTokens() {
    Task {
      await viewModel.getTokensList()
    }
  }
}

extension HomeView {
  func tokenList(isDetail: Bool = false) -> some View {
    VStack {
      if !isDetail {
        HStack(alignment: .center) {
          Text("Tokens")
            .font(.system(size: 15, weight: .semibold))
            .foregroundColor(Color(Colors.Label.secondary))
            .padding(.top, 16)
            .opacity(viewModel.tokens.count == 0 ? 0 : 1)
          Spacer()
          Button {
            showTokensDetail.toggle()
          } label: {
            Text("More")
              .font(.system(size: 15, weight: .semibold))
              .foregroundColor(Color(Colors.Label.secondary))
              .padding(.top, 16)
              .opacity(viewModel.tokens.count == 0 ? 0 : 1)
          }
        }
      }
      VStack(spacing: 0) {
        ForEach(isDetail == true ? viewModel.tokens : Array(viewModel.tokens.prefix(5)), id: \.self) { token in
          TokenItem(token: token)
        }
      }
    }
  }

  func appsList(isDetail: Bool = false) -> some View {
    VStack {
      if !isDetail {
        HStack {
          Text("Apps")
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
        ForEach(isDetail == true ? viewModel.configurations : Array(viewModel.configurations.prefix(5)), id: \.self) { configuration in
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
