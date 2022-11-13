import SwiftUI
import SDWebImageSwiftUI
import UIComponents
import Commons
import Domain
import Import
import UniformTypeIdentifiers

public struct ProfileSelectorView: View {
    @ObservedObject
    var viewModel: ProfileSelectorViewModel

    @Environment(\.presentationMode)
    var presentationMode

    @State private var editState = false
    @State private var showingAlert = false
    @State private var showingImport = false
    @State private var showingCreate = false
    @State private var draggingItem: EthereumWallet?
    @State private var tappedWallet: EthereumWallet?
    @State private var selectedWallet: EthereumWallet?

    public init(viewModel: ProfileSelectorViewModel = ProfileSelectorViewModel()) {
        self.viewModel = viewModel
    }

    public var body: some View {
        NavigationView {
            VStack {
                ScrollView {
                    walletsList
                    createOrImportSection
                }
                .toolbar {
                    Button(action: {
                        self.editState.toggle()
                    }) {
                        Text(editState ? "Done" : "Edit")
                            .font(.system(size: 15, weight: .semibold))
                            .padding([.top, .bottom], 8).padding([.leading, .trailing], 12)
                            .foregroundColor(Color(Colors.Label.primary))
                            .background(Color(Colors.System.secondary))
                            .cornerRadius(24)
                    }
                }
            }
            .background(Color(Colors.Background.primary))
            .navigationBarTitle("Wallet", displayMode: .inline)
            Spacer()
        }.onAppear {
            refreshWallets()
        }
    }

    var walletsList: some View {
        VStack(spacing: 0) {
            ForEach(viewModel.wallets, id: \.self) { wallet in
                HStack {
                     Image(wallet.color.rawValue)
                         .resizable()
                         .frame(width: 36, height: 36)
                         .clipShape(Circle())
                     VStack(alignment: .leading, spacing: 0) {
                         Text(wallet.name)
                             .foregroundColor(Color(Colors.Label.primary))
                             .font(Font.system(size: 17, weight: .regular))
                             ._lineHeightMultiple(1.09)
                         Text(wallet.address.eip55Description.addressFormat())
                             .foregroundColor(Color(Colors.Label.secondary))
                             .font(Font.system(size: 12, weight: .regular))
                             ._lineHeightMultiple(1.12)
                     }
                     .padding([.bottom], 2)
                     Spacer()
                     if editState {
                         Image(systemName: "minus.circle.fill")
                             .resizable()
                             .transition(.opacity.animation(.default))
                             .frame(width: 24, height: 24)
                             .padding(.trailing, 24)
                             .foregroundColor(Color(Colors.System.red))
                     } else {
                         Image(systemName: "checkmark.circle.fill")
                             .resizable()
                             .transition(.opacity.animation(.default))
                             .frame(width: 24, height: 24)
                             .padding(.trailing, 24)
                             .foregroundColor(Color(Colors.System.green))
                             .disabled(wallet != self.selectedWallet)
                             .opacity(wallet == self.selectedWallet ? 1.0 : 0.0)
                     }
                }
                .contentShape(Rectangle())
                .frame(maxWidth: .infinity)
                .padding([.top, .bottom], 8).padding(.leading, 16)
                .onTapGesture {
                    if editState {
                        self.tappedWallet = wallet
                        self.showingAlert.toggle()
                    } else {
                        self.selectedWallet = wallet
                        self.viewModel.select(wallet: wallet)
                    }
                }
                .drag(if: editState, data: {
                    draggingItem = wallet
                    return NSItemProvider(object: "\(wallet.address.eip55Description)" as NSString)
                })
                .onDrop(of: [UTType.text], delegate: DragDelegate(
                    item: wallet,
                    listData: viewModel.wallets,
                    current: $draggingItem
                ) { from, to in
                    withAnimation {
                        viewModel.wallets.move(fromOffsets: from, toOffset: to)
                    }
                })
                .alert("Are you sure you want to remove this wallet?", isPresented: $showingAlert, actions: {
                    Button("Remove", role: .destructive) {
                        if let wallet = self.tappedWallet {
                            delete(with: wallet)
                        }
                    }
                })
                if wallet != viewModel.wallets.last {
                    Rectangle()
                        .fill(Color(Colors.Separator.transparency))
                        .frame(height: 0.5)
                        .padding(.leading, 54)
                }
            }
        }
        .animation(.spring(), value: viewModel.wallets)
        .background(Color(Colors.System.secondary))
        .cornerRadius(14)
        .padding([.leading, .top, .bottom, .trailing], 16)
    }

    var createOrImportSection: some View {
        VStack(spacing: 0) {
            ZStack {
                HStack(spacing: 10) {
                    ColoredIconView(imageName: "plus.circle", foregroundColor: Color(.white), backgroundColor: Color(.green))
                        .padding([.top, .bottom], 7)
                    Text("Create New Wallet")
                        .font(Font.system(size: 17, weight: .regular))
                        ._lineHeightMultiple(1.08)
                    Spacer()
                }
            }
            .padding([.leading], 16)
            .contentShape(Rectangle())
            .frame(maxWidth: .infinity)
            .onTapGesture {
                viewModel.createWallet()
                refreshWallets()
            }
            Rectangle()
                .fill(Color(Colors.Separator.transparency))
                .frame(height: 0.5)
                .padding(.leading, 54)
            ZStack {
                HStack(spacing: 10) {
                    ColoredIconView(imageName: "square.and.arrow.down", foregroundColor: Color(.white), backgroundColor: Color(.blue))
                        .padding([.top, .bottom], 7)
                    Text("Import Wallet")
                        .font(Font.system(size: 17, weight: .regular))
                        ._lineHeightMultiple(1.08)
                    Spacer()
                }
            }
            .padding([.leading], 16)
            .contentShape(Rectangle())
            .frame(maxWidth: .infinity)
            .onTapGesture {
                showingImport.toggle()
            }
            .sheet(isPresented: $showingImport, onDismiss: {
                refreshWallets()
            }) {
                ImportView()
            }
        }
        .background(Color(Colors.System.secondary))
        .cornerRadius(14)
        .padding([.leading, .top, .trailing], 16)
    }

    func delete(with wallet: EthereumWallet) {
        do {
            try viewModel.deleteWallet(with: wallet)
            refreshWallets()
        } catch {
            print(error.localizedDescription)
        }
    }

    private func refreshWallets() {
        viewModel.getWallets()
        self.selectedWallet = viewModel.selectedWallet()
    }
}
