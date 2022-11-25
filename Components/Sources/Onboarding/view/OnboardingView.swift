import SwiftUI
import Commons
import UIComponents
import Import

public struct OnboardingView: View {
    @ObservedObject
    var viewModel = OnboardingViewModel()
    
    @Environment(\.presentationMode)
    var presentationMode
    
    @State private var isPresentingEditView = true
    
    public init() { }
    
    public var body: some View {
        
        VStack(alignment: .leading, spacing: 0) {
            VStack(alignment: .leading, spacing: 12) {
                Text("Add to Light Wallet")
                    .fontWeight(.bold)
                    .font(.system(size: 35))
                
                Text("Start by adding your wallet, a new home for your web3 activites.").font(.system(size: 16)).foregroundColor(Color(Colors.Label.secondary))
            }.padding(.horizontal, 20)
            
            VStack(spacing: 0) {
                ZStack {
                    HStack(spacing: 10) {
                        ColoredIconView(imageName: "plus.circle", foregroundColor: Color(.white), backgroundColor: Color(Colors.System.green))
                            .padding([.top, .bottom], 7)
                        Text("Create New Wallet")
                            .font(Font.system(size: 17, weight: .regular))
                            .foregroundColor(Color(Colors.Label.primary))
                            ._lineHeightMultiple(1.08)
                        Spacer()
                    }.onTapGesture {
                        self.viewModel.createMainWallet()
                    }
                }
                .padding([.leading], 16)
                .contentShape(Rectangle())
                .frame(maxWidth: .infinity)
                Rectangle()
                    .fill(Color(Colors.Separator.transparency))
                    .frame(height: 0.5)
                    .padding(.leading, 54)
                ZStack {
                    NavigationLink(destination: ScrollView {
                        VStack(spacing: 0) {
                            HStack {
                                Text("Choose how you would like to import your wallet")
                                    .font(.system(size: 13, weight: .regular))
                                    .foregroundColor(Color(Colors.Label.secondary))
                                    .padding(.leading, 16)
                                Spacer()
                            }.padding(.top, 23)
                            VStack(spacing: 16) {
                                NavigationLink(destination: ImportHDWalletView(primary: true)) {
                                    ImportViewCategoryItem(icon: "ellipsis.rectangle.fill", color: Color(Colors.System.purple), title: "With Recovery Phrase", description: "Import wallets with a 12 word recovery phrase")
                                }
                                NavigationLink(destination: ImportPrivateKeyView()) {
                                    ImportViewCategoryItem(icon: "key.fill", color: Color(Colors.System.orange), title: "With Private Key", description: "Import a wallet by entering its private key.")
                                }
                            }.padding(.top, 8).padding([.leading, .trailing], 16)
                            Spacer()
                        }
                        .navigationBarTitle("Import or Restore Wallet", displayMode: .inline)
                    }) {
                        HStack(spacing: 10) {
                            ColoredIconView(imageName: "square.and.arrow.down", foregroundColor: Color(.white), backgroundColor: Color(Colors.System.blue))
                                .padding([.top, .bottom], 7)
                            Text("Import Wallet")
                                .font(Font.system(size: 17, weight: .regular))
                                .foregroundColor(Color(Colors.Label.primary))
                                ._lineHeightMultiple(1.08)
                            Spacer()
                        }
                    }
                }
                .padding([.leading], 16)
                .contentShape(Rectangle())
                .frame(maxWidth: .infinity)
            }
            .background(Color(Colors.System.secondary))
            .cornerRadius(14)
            .padding([.leading, .trailing], 16)
            .padding(.top, 30)

            Spacer()
        }.sheet(isPresented: $isPresentingEditView) {
            VStack(alignment: .leading, spacing: 0) {
                VStack(alignment: .leading, spacing: 12) {
                    Text("Getting Started in Light Wallet")
                        .fontWeight(.bold)
                        .font(.system(size: 35))
                    
                }.padding(.horizontal, 20).padding(.top, 60).padding(.bottom, 30)
                
                VStack(alignment: .leading) {
                    FeatureDetail(image: "safari.fill", title: "Safari Extension", description: "Instant access to all dapps, at the convenience of your fingertips inside the Safari browser.")
                    FeatureDetail(image: "lock.shield.fill", title: "Security", description: "Secure your funds & assets using Apple's native Secure Encalve.")
                    FeatureDetail(image: "checkmark.seal.fill", title: "Open Source & Native", description: "We believe in a privacy focused, open & transparent, native wallet infrastructure for Ethereum.")
                }
                
                Spacer()
                
                Button(action: {isPresentingEditView=false}){
                    Text("Get Started")
                        .foregroundColor(.white)
                        .font(.system(size: 18, weight: .medium))
                        .frame(maxWidth: .infinity, maxHeight: 60.0)
                        .background(Color.blue)
                        .cornerRadius(15)
                        .padding(.top, 50)
                        .padding(.horizontal, 30)
                        .padding(.bottom, 20)
                }
            }
        }
    }
    
    func createMainWallet()  {
        do {
            try viewModel.createMainWallet()
            AppOrchestra.onboarding()
        } catch {
            print(error.localizedDescription)
        }
    }
}

struct FeatureDetail: View {
    var image: String
    var title: String
    var description: String
    
    var body: some View {
        HStack(alignment: .top) {
            Image(systemName: image)
                .resizable()
                .scaledToFit()
                .padding(10.0)
                .frame(width: 48, height: 48)
                .foregroundColor(Color(Colors.Background.primary))
                .background(Color(Colors.Label.primary))
                .cornerRadius(.infinity)
                .padding([.top], 2.0)
                .padding([.trailing], 8.0)
            
            
            VStack(alignment: .leading) {
                Text(title).bold().font(.system(size: 21)).padding([.bottom], 1.0)
                
                Text(description).font(.system(size: 15)).foregroundColor(Color(Colors.Label.secondary))
            }
            
        }.padding([.leading, .trailing], 20.0).padding([.top], 20.0)
    }
}
