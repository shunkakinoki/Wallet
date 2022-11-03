import SwiftUI
import Commons
import UIComponents

public struct SettingsView: View {

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
                            Image("EditIcon")
                                .frame(width: 30, height: 30)
                            Text("Edit")
                                .font(.custom(font: .inter, size: 17, weight: .regular))
                        }
                    }
                    NavigationLink(destination: WalletBackupView()) {
                        HStack(spacing: 16) {
                            Image("BackupSettingsIcon")
                            Text("Backup")
                                .font(.custom(font: .inter, size: 17, weight: .regular))
                        }
                    }
                    HStack(spacing: 16) {
                        Image("DarkModeSettingsIcon")
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
                    SettingsViewItem(image: "TermsSettingsIcon", linkName: "Terms of Conditions", linkUrl: "https://lightdotso.notion.site/38d646143772410887a0e6cae3ee0e56")
                    SettingsViewItem(image: "PrivacySettingsIcon", linkName: "Privacy Policy", linkUrl: "https://lightdotso.notion.site/81dbf21d7bca4b9285a13392edbf575e")
                    SettingsViewItem(image: "FaqSettingsIcon", linkName: "FAQ", linkUrl: "https://lightdotso.notion.site/d9a70e761b9e4290bc2b8e58cd71a70c")
                    SettingsViewItem(image: "TwitterSettingsIcon", linkName: "Follow @LightDotSo", linkUrl: "https://twitter.com/lightDotSo/")
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

    func deleteWallets() {
        let spec: NSDictionary = [kSecClass: kSecClassKey]
        SecItemDelete(spec)
    }
}

struct SettingsViewItem: View {

    let image: String
    let linkName: String
    let linkUrl: String

    var body: some View {
        HStack(spacing: 16) {
            Image(image)
            Link(linkName, destination: URL(string: linkUrl)!)
                .foregroundColor(Color(Colors.Label.primary))
                .font(.custom(font: .inter, size: 17, weight: .regular))
        }
    }
}
