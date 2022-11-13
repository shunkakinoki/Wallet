import SwiftUI
import Commons
import UIComponents

public struct SettingsView: View {
    @ObservedObject
    var viewModel = SettingsViewModel()

    @Environment(\.presentationMode)
    var presentationMode

    @State
    private var appTheme = AppTheme.isDarkMode()

    public init() { }

    public var body: some View {
        NavigationView {
            Form {
                Section {
                    NavigationLink(destination: WalletEditView()) {
                        HStack(spacing: 16) {
                            ColoredIconView(imageName: "pencil.circle.fill", foregroundColor: Color(.white), backgroundColor: Color(.green))
                                .frame(width: 30, height: 30)
                            Text("Edit")
                                .font(.custom(font: .inter, size: 17, weight: .regular))
                        }
                    }
                    NavigationLink(destination: WalletBackupView()) {
                        HStack(spacing: 16) {
                            ColoredIconView(imageName: "arrow.triangle.2.circlepath.circle.fill", foregroundColor: Color(.white), backgroundColor: Color(.orange))
                            Text("Backup")
                                .font(.custom(font: .inter, size: 17, weight: .regular))
                        }
                    }
                    HStack(spacing: 16) {
                        ColoredIconView(imageName: "paintpalette.fill", foregroundColor: Color(.white), backgroundColor: Color(.purple))
                        Toggle("Dark mode", isOn: $appTheme)
                            .toggleStyle(SwitchToggleStyle(tint: .green))
                            .font(.custom(font: .inter, size: 17, weight: .regular))
                            .onChange(of: appTheme) { newValue in
                                UserDefaults.standard.set(newValue, forKey: "InterfaceDesign")
                                NotificationCenter.default.post(name: newValue ? .changeDarkTheme : .changeLightTheme, object: nil)
                            }
                    }
                } header: {
                    Text("Preferences".uppercased())
                        .font(.system(size: 12, weight: .medium))
                }
                .padding([.top, .bottom], 2.5)
                .textCase(nil)
                Section {
                     HStack(spacing: 16) {
                        ColoredIconView(imageName: "doc.plaintext.fill", foregroundColor: Color(.white), backgroundColor: Color(.gray))
                        Link("Terms of Conditions", destination: URL(string: "https://lightdotso.notion.site/38d646143772410887a0e6cae3ee0e56")!)
                            .foregroundColor(Color(Colors.Label.primary))
                            .font(.custom(font: .inter, size: 17, weight: .regular))
                    }
                     HStack(spacing: 16) {
                        ColoredIconView(imageName: "hand.raised.circle", foregroundColor: Color(.white), backgroundColor: Color(.purple))
                        Link("Privacy Policy", destination: URL(string: "https://lightdotso.notion.site/81dbf21d7bca4b9285a13392edbf575e")!)
                            .foregroundColor(Color(Colors.Label.primary))
                            .font(.custom(font: .inter, size: 17, weight: .regular))
                    }
                     HStack(spacing: 16) {
                        ColoredIconView(imageName: "questionmark.circle", foregroundColor: Color(.white), backgroundColor: Color(.blue))
                        Link("FAQ", destination: URL(string: "https://lightdotso.notion.site/d9a70e761b9e4290bc2b8e58cd71a70c")!)
                            .foregroundColor(Color(Colors.Label.primary))
                            .font(.custom(font: .inter, size: 17, weight: .regular))
                    }
                    HStack(spacing: 16) {
                        Image("TwitterSettingsIcon")
                        Link("Follow @Light_Wallet", destination: URL(string: "https://twitter.com/Light_Wallet")!)
                            .foregroundColor(Color(Colors.Label.primary))
                            .font(.custom(font: .inter, size: 17, weight: .regular))
                    }
                } header: {
                    Text("Resources".uppercased())
                        .font(.system(size: 12, weight: .medium))
                }
                .padding([.top, .bottom], 2.5)
                .textCase(nil)
                Section {
                    Button(action: { self.deleteWallets() }) {
                        Text("Delete Wallets")
                            .foregroundColor(Color(Colors.Label.primary))
                            .font(.custom(font: .inter, size: 17, weight: .regular))
                    }
                } header: {
                    Text("DEVELOPMENT".uppercased())
                        .font(.system(size: 12, weight: .medium))
                }
            }
            .padding(.top, -18)
            .navigationBarTitle("Settings", displayMode: .inline)
            .toolbar { CloseToolbar { presentationMode.wrappedValue.dismiss() } }
            Spacer()
        }
    }

    func deleteWallets()  {
        do {
            try viewModel.deleteAllAccounts()
            AppOrchestra.onboarding()
        } catch {
            print(error.localizedDescription)
        }
    }
}
