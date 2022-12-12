import Commons
import Foundation
import SPAlert
import SwiftUI

public struct ShowSeedPhraseView: View {

  @StateObject
  var viewModel: ShowSeedPhraseViewModel

  @State
  private var showAlert = false

  public init(viewModel: ShowSeedPhraseViewModel) {
    _viewModel = StateObject(wrappedValue: viewModel)
  }

  let columns = [
    GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible()),
  ]

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
          Text("Never share the recovery phrase. Anyone with it has full access to your wallet.")
            .foregroundColor(Color(Colors.Label.secondary))
            .font(.system(size: 16, weight: .regular))
          Spacer()
        }
        .padding([.leading, .bottom], 16).padding(.top, 8)
        LazyVGrid(columns: columns, spacing: 8) {
          ForEach(Array(getPrivateKey().split(separator: " ").enumerated()), id: \.offset) {
            index, seed in
            ZStack {
              HStack(spacing: 4) {
                Text("\(index + 1). ")
                  .font(.system(size: 14, weight: .medium))
                  .foregroundColor(Color(Colors.Label.secondary))
                Text(seed)
                  .font(.system(size: 14, weight: .medium))
                  .foregroundColor(Color(Colors.Label.primary))
                Spacer()
              }
              .padding([.top, .bottom, .leading], 8)
            }
            .contentShape(Rectangle())
            .background(Color(Colors.System.secondary))
            .cornerRadius(14)
          }
        }
        .padding([.leading, .trailing, .top], 16)
        Spacer()
      }
      .padding(.top, 30)
      Spacer()
      Button {
        UIPasteboard.general.setValue(
          getPrivateKey(),
          forPasteboardType: "public.plain-text"
        )
        showAlert = true
      } label: {
        HStack {
          Image(systemName: "checkmark.circle.fill")
            .resizable()
            .frame(width: 19.5, height: 19.5)
            .foregroundColor(Color(Colors.Label.secondary))
            .padding(2.5)
          Text("Copy")
            .font(.system(size: 17, weight: .semibold))
            .padding([.top, .bottom], 14)
            .foregroundColor(Color(Colors.Label.primary))
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
      }.SPAlert(
        isPresent: $showAlert,
        title: "Copied!",
        preset: .done,
        haptic: .success
      )

    }
    .tint(.white)
    .navigationBarTitle("Seed Phrase", displayMode: .inline)
  }

  func getPrivateKey() -> String {
    do {
      let privateKey = try viewModel.getSeedPhrase()
      return String(decoding: privateKey, as: UTF8.self)
    } catch {
      return "Error"
    }
  }
}
