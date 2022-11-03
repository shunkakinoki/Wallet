import Foundation
import SwiftUI

public extension View {
    func drag(if condition: Bool, data: @escaping () -> NSItemProvider) -> some View {
        self.modifier(Draggable(condition: condition, data: data))
    }
}

public struct Draggable: ViewModifier {
    let condition: Bool
    let data: () -> NSItemProvider

    @ViewBuilder
    public func body(content: Content) -> some View {
        if condition {
            content
                .onDrag(data)
        } else {
            content
        }
    }
}
