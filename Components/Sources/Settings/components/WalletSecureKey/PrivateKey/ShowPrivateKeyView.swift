import Foundation
import SwiftUI
import Commons

public struct ShowPrivateKeyView: View {

    @StateObject
    var viewModel: ShowPrivateKeyViewModel

    public init(viewModel: ShowPrivateKeyViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }

    public var body: some View {
        VStack {
            VStack(spacing: 0) {
                HStack {
                    Text("For your eye only")
                        .foregroundColor(Color(Colors.Label.primary))
                        .font(.system(size: 20, weight: .semibold))
                    Spacer()
                }
                .padding(.leading, 16).padding(.top, 8)
                HStack {
                    Text("Never share your private key. Anyone with it has full access to your wallet.")
                        .foregroundColor(Color(Colors.Label.secondary))
                        .font(.system(size: 16, weight: .regular))
                    Spacer()
                }
                .padding([.leading, .bottom], 16).padding(.top, 8)
                ZStack {
                    HStack {
                        Text(getPrivateKey())
                            .foregroundColor(Color(Colors.Label.secondary))
                            .padding([.leading, .trailing], 16).padding([.top, .bottom], 11)
                            .font(.system(size: 17, weight: .regular))
                        Spacer()
                    }
                }
                .contentShape(Rectangle())
                .frame(maxWidth: .infinity)
                .background(Color(Colors.System.secondary))
                .cornerRadius(14)
                .padding([.leading, .top, .trailing], 16)
                Spacer()
            }
            .padding(.top, 30)
            Spacer()
            Button {
                UIPasteboard.general.setValue(
                    getPrivateKey(),
                    forPasteboardType: "public.plain-text"
                )
            } label: {
                HStack {
                    Image(systemName: "checkmark.circle.fill")
                        .resizable()
                        .frame(width: 19.5, height: 19.5)
                        .foregroundStyle(.white)
                        .padding(2.5)
                    Text("Copy")
                        .font(.system(size: 17, weight: .bold))
                        .padding([.top, .bottom], 14)
                        .foregroundColor(.white)
                }
                .frame(maxWidth: .infinity)
                .background(Color(Colors.Background.secondary))
                .clipShape(RoundedRectangle(cornerRadius: 14))
                .overlay(
                    RoundedRectangle(cornerRadius: 14)
                        .stroke(Color(Colors.Separator.transparency), lineWidth: 1)
                )
                .padding(.bottom, 20)
                .padding([.leading, .trailing], 16)
            }
        }
        .navigationBarTitle("Private Key", displayMode: .inline)
    }

    func getPrivateKey() -> String {
        do {
            let privateKey = try viewModel.getPrivateKey()
            return privateKey.toHexString().withHexPrefix
        } catch {
            return "Error"
        }
    }
}
