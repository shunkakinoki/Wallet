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
        
        VStack {
            Text("Add to Light Wallet")
                .fontWeight(.heavy)
                .font(.system(size: 45))
                .padding(4.0)
            
            Form {
                Section {
                    HStack(spacing: 16) {
                        ColoredIconView(imageName: "plus.circle", foregroundColor: Color(.white), backgroundColor: Color(Colors.System.green))
                            .frame(width: 30, height: 30)
                        Text("Create New Wallet")
                            .font(.custom(font: .inter, size: 17, weight: .regular))
                    }.onTapGesture {
                        self.viewModel.createMainWallet()
                    }
                    
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
                        HStack(spacing: 16) {
                            ColoredIconView(imageName: "square.and.arrow.down", foregroundColor: Color(.white), backgroundColor: Color(Colors.System.blue))
                            Text("Import Existing Wallet")
                                .font(.custom(font: .inter, size: 17, weight: .regular))
                        }
                    }
                }
            }
        }.sheet(isPresented: $isPresentingEditView) {
            Spacer()
            Text("Getting Started in Light Wallet")
                .fontWeight(.heavy)
                .font(.system(size: 50))
            
            
            VStack(alignment: .leading) {
                FeatureDetail(image: "heart.fill", imageColor: .pink, title: "Safari Extension", description: "Experience access to all dappsat the convenience of your fingertips.")
                FeatureDetail(image: "paperclip", imageColor: .red, title: "Security", description: "Secure your funds using Apple's native Secure Encalve.")
                FeatureDetail(image: "play.rectangle.fill", imageColor: .blue, title: "Open Source & Native", description: "We believe in a privacy focused, open & transparent, native wallet infrastructure for Ethereum.")
            }
            
            Spacer()
            
            Button(action: {isPresentingEditView=false}){
                Text("Next")
                    .foregroundColor(.white)
                    .font(.headline)
                    .frame(width: 350, height: 60)
                    .background(Color.blue)
                    .cornerRadius(15)
                    .padding(.top, 50)
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
    var imageColor: Color
    var title: String
    var description: String
    
    var body: some View {
        HStack(alignment: .center) {
            HStack {
                Image(systemName: image)
                    .font(.system(size: 50))
                    .frame(width: 50)
                    .foregroundColor(Color(Colors.Label.primary))
                    .padding()
                
                VStack(alignment: .leading) {
                    Text(title).bold()
                    
                    Text(description)
                        .fixedSize(horizontal: false, vertical: true)
                }
            }.frame(width: 340, height: 100)
        }
    }
}
