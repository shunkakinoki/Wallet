import Foundation
import SwiftUI

public struct BackToolbar: ToolbarContent {

    var back: () -> Void

    public init(back: @escaping () -> Void) {
        self.back = back
    }

    public var body: some ToolbarContent {
        ToolbarItem(placement: .navigationBarLeading) {
            Button(action: back) {
                Image("InverseBack").tabBar()
            }
        }
    }
}
