import Foundation
import SwiftUI
import Commons

public struct CloseToolbar: ToolbarContent {

    var back: () -> Void

    public init(back: @escaping () -> Void) {
        self.back = back
    }

    public var body: some ToolbarContent {
        ToolbarItem(placement: .navigationBarLeading) {
            Button(action: back) {
                Image(systemName: "xmark")
                    .resizable()
                    .frame(width: 12, height: 12)
                    .foregroundColor(Color(Colors.Label.secondary.withAlphaComponent(0.60)))
                    .padding(9)
                    .background(Color(Colors.Fill.quaternary))
                    .clipShape(Circle())
            }
        }
    }
}
