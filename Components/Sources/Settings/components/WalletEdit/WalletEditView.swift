import Commons
import Domain
import Foundation
import Keychain
import Session
import SwiftUI

public struct WalletEditView: View {

  @ObservedObject
  var viewModel: WalletEditViewModel

  @State
  public var sheet: Bool

  @State
  public var text = ""

  @State
  public var selected: String = ""

  public init(viewModel: WalletEditViewModel = WalletEditViewModel(), sheet: Bool = false) {
    self.viewModel = viewModel
    self.sheet = sheet
    _text = State(initialValue: viewModel.getName())
    _selected = State(initialValue: viewModel.getColor())
  }

  let columns = [
    GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible()),
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
        LazyVGrid(columns: columns, spacing: 10) {
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
                    ZStack {
                      selected == color
                        ? Circle().stroke(Color(Colors.Label.primary), lineWidth: 4)
                        : Circle().stroke(Color(Colors.System.secondary), lineWidth: 4)
                      Circle().strokeBorder(Color(Colors.System.secondary), lineWidth: 4)
                    }
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
    .padding(.top, sheet ? 45 : 12)
    .navigationBarTitle("Edit", displayMode: .inline)
  }
}
