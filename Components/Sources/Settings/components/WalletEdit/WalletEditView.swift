import Foundation
import SwiftUI
import Session
import Domain
import Keychain
import Commons

public struct WalletEditView: View {

    @ObservedObject
    var viewModel: WalletEditViewModel

    @State
    public var text = ""

    @State
    public var selected: String = ""

    init(viewModel: WalletEditViewModel = WalletEditViewModel()) {
        self.viewModel = viewModel
        _text = State(initialValue: viewModel.getName())
        _selected = State(initialValue: viewModel.getColor())
    }

    let columns = [
        GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible())
    ]

    public var body: some View {
        VStack(spacing: 0) {
            ZStack {
                TextField("", text: $text)
                    .truncationMode(.tail)
                    .keyboardType(.alphabet)
                    .disableAutocorrection(true)
                    .font(.system(size: 17, weight: .regular))
                    .onChange(of: text) { value in
                        viewModel.editName(value)
                    }
                    .frame(height: 44)
                    .padding(.leading, 16)
            }
            .contentShape(Rectangle())
            .frame(maxWidth: .infinity)
            .background(Color(Colors.System.secondary))
            .cornerRadius(16)
            .padding([.leading, .top, .trailing], 16)
            ZStack {
                LazyVGrid(columns: columns, spacing: 34) {
                    ForEach(viewModel.getColors(), id: \.self) { color in
                        ZStack {
                            HStack(spacing: 4) {
                                Image(color)
                                    .onTapGesture {
                                        selected = color
                                        viewModel.editColor(color)
                                    }
                                    .clipShape(Circle())
                                    .overlay(
                                        selected == color ?
                                        Circle().stroke(Color.white, lineWidth: 8) :
                                        Circle().stroke(Color.white, lineWidth: 0)
                                    )
                            }
                            .padding([.top, .bottom, .leading, .trailing], 8)
                        }
                        .contentShape(Rectangle())
                        .background(Color(Colors.System.secondary))
                        .cornerRadius(14)
                    }
                }
                .padding([.leading, .trailing, .top, .bottom], 16)
            }
            .contentShape(Rectangle())
            .frame(maxWidth: .infinity)
            .background(Color(Colors.System.secondary))
            .cornerRadius(16)
            .padding([.leading, .top, .trailing], 16)
            Spacer()
        }
        .navigationBarTitle("Edit", displayMode: .inline)
    }
}
