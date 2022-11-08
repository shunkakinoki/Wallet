import SwiftUI
import Commons
import SDWebImageSwiftUI
import UIComponents
import Settings

struct HomeView: View {
    @ObservedObject
    var viewModel: HomeViewModel = HomeViewModel()

    @State
    private var visibleAccount = false

    @State
    private var showingQR = false

    @State
    private var showingSettings = false

    var body: some View {
        VStack {
            HStack(alignment: .center) {
                walletSelectorButton
                Spacer()
                settingsButton
            }
            ScrollView {
                HStack(spacing: 15) {
                    Button {
                        UIPasteboard.general.setValue(
                            viewModel.selectedRawAddress,
                            forPasteboardType: "public.plain-text"
                        )
                    } label: {
                        Text("Copy Address")
                            .font(.system(size: 17, weight: .bold))
                            .padding([.top, .bottom], 14)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .background(Color(Colors.Background.secondary))
                            .clipShape(RoundedRectangle(cornerRadius: 14))
                            .overlay(
                                RoundedRectangle(cornerRadius: 14)
                                    .stroke(Color(Colors.Separator.transparency), lineWidth: 1)
                            )
                            .padding(.top, 25)
                    }
                    Button {
                        showingQR.toggle()
                    } label: {
                        Text("Show QR")
                            .font(.system(size: 17, weight: .bold))
                            .padding([.top, .bottom], 14)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .background(Color(Colors.Background.secondary))
                            .clipShape(RoundedRectangle(cornerRadius: 14))
                            .overlay(
                                RoundedRectangle(cornerRadius: 14)
                                    .stroke(Color(Colors.Separator.transparency), lineWidth: 1)
                            )
                            .padding(.top, 25)
                    }.sheet(isPresented: $showingQR) {
                        ShowQR(text: viewModel.selectedRawAddress)
                    }
                }
                Link(destination: URL(string: "https://wallet.light.so")!) {
                    ImportViewCategoryItem(icon: ["SafariIcon", "ExtensionIcon"], title: "Set Up Light for Safari", description: "Set up Light Safari Extension to use Light on any website, right from Safari")
                        .padding(.top, 10)
                        .multilineTextAlignment(.leading)
                }
                HStack {
                    Text("Apps")
                        .font(.system(size: 15, weight: .semibold))
                        .foregroundColor(Color(Colors.Label.secondary))
                        .padding(.top, 16)
                        .opacity(viewModel.configurations.count == 0 ? 0 : 1)
                    Spacer()
                }
                VStack(spacing: 0) {
                    ForEach(viewModel.configurations, id: \.self) { configuration in
                        Link(destination: URL(string: "https://\(configuration.host)")!) {
                            HStack {
                                WebImage(url: URL(string: "https://\(configuration.host)/\(configuration.favicon ?? "favicon.ico")"))
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
            Spacer()
        }
        .onReceive(NotificationCenter.default.publisher(for: UIApplication.willEnterForegroundNotification)) { _ in
            viewModel.getConfiguration()
        }
        .onAppear {
            viewModel.getWalletSelected()
            viewModel.getConfiguration()
        }
        .padding([.leading, .trailing, .top], 16)
        Spacer()
    }

    var walletSelectorButton: some View {
        Button(action: { visibleAccount.toggle() }) {
            WalletSelector(walletColor: viewModel.color, walletName: viewModel.name, walletAddress: viewModel.selectedAddress)
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
    }
}
