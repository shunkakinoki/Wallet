import Foundation
import SwiftUI

struct ShowSheet<Content: View>: View {
    @Binding var isPresented: Bool
    @ViewBuilder let content: Content

    var body: some View {
        contentView
            .animation(.interactiveSpring(), value: isPresented)
            .ignoresSafeArea()
    }

    private var contentView: some View {
        content
            .frame(maxWidth: .infinity)
    }
}
