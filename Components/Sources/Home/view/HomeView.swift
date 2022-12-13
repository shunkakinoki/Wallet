import Commons
import SDWebImageSwiftUI
import SPAlert
import Settings
import SwiftUI
import UIComponents

public struct HomeView: View {
  @ObservedObject
  var viewModel: HomeViewModel = HomeViewModel()

  @State
  private var visibleAccount = false

  @State
  private var showTokensDetail = false

  @State
  private var showAppsDetail = false

  @State
  private var showEdit = false

  @State
  private var showingMore = false

  @State
  private var showingQR = false

  @State
  private var showToast = false

  @State
  private var showingSettings = false

  public init() {}

  public var body: some View {
    NavigationView {
      ScrollView {
        VStack {
          HStack(alignment: .center) {
            walletSelectorButton
            Spacer()
          }

          HStack(alignment: .center, spacing: 0) {
            Text("$")
              .foregroundColor(Color(Colors.Label.secondary))
              .font(.system(size: 24, weight: .semibold))
            if viewModel.isLoading {
              Rectangle()
                .fill(Color(Colors.Background.secondary))
                .frame(width: 80, height: 30, alignment: .center)
                .clipShape(RoundedRectangle(cornerRadius: 25.0, style: .continuous))
                .shimmer()
                .padding([.leading], 2.0)
            } else {
              Text(String(format: "%.2f", viewModel.address.netWorth))
                .font(.system(size: 24, weight: .semibold))
                .foregroundColor(Color(Colors.Label.secondary))
            }
            if viewModel.isValidating {
              ProgressView()
                .padding([.leading], 4.0)
            }
            Spacer()
          }.padding([.top, .bottom], 8.0)

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
                Text("Receive")
                  .font(.body)
                  .foregroundColor(Color(Colors.Label.primary))
              }
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
                  showEdit.toggle()
                }) {
                  Label("Edit Wallet", systemImage: "pencil")
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
                  Text(
                    "Set up Light Safari Extension to use Light on any website, right from Safari"
                  )
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
          refreshWallet()
        }
        .sheet(isPresented: $showingQR) {
          ShowQR(text: viewModel.selectedRawAddress)
        }
        .sheet(isPresented: $showEdit, onDismiss: onDismiss) {
          WalletEditView()
          // if #available(iOS 16.0, *) {
          //   WalletEditView(sheet: true)
          //     .presentationDetents([.medium])
          //     .presentationDragIndicator(.visible)
          // } else {
          // WalletEditView()
          // }
        }
        .sheet(isPresented: $showTokensDetail) {
          tokenDetail
        }
        .sheet(isPresented: $showAppsDetail) {
          appsDetail
        }
        .SPAlert(
          isPresent: $showToast,
          title: "Copied!",
          preset: .done,
          haptic: .success
        )
        .padding([.leading, .trailing], 16)
        .padding([.top], 8)
        Spacer()
      }
      .refreshable {
        viewModel.refresh()
      }
      .navigationTitle("Light Wallet")
      .navigationBarItems(
        trailing:
          settingsButton
      )
    }
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
    refreshWallet()
    viewModel.isLoading = true
  }

  private func refreshTokens() {
    Task {
      await viewModel.getTokensList()
    }
  }

  private func refreshWallet() {
    Task {
      await viewModel.getWalletAddress()
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
        ForEach(
          isDetail == true ? viewModel.tokens : Array(viewModel.tokens.prefix(10)), id: \.self
        ) { token in
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
