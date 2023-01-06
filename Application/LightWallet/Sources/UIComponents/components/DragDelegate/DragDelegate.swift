import Foundation
import SwiftUI

public struct DragDelegate<Item: Equatable>: DropDelegate {
  let item: Item
  var listData: [Item]
  var moveAction: (IndexSet, Int) -> Void
  @Binding var current: Item?

  public init(
    item: Item, listData: [Item], current: Binding<Item?>,
    moveAction: @escaping (IndexSet, Int) -> Void
  ) {
    self._current = current
    self.item = item
    self.listData = listData
    self.moveAction = moveAction
  }

  public func dropEntered(info: DropInfo) {
    guard item != current, let current = current else { return }
    guard let from = listData.firstIndex(of: current), let to = listData.firstIndex(of: item) else {
      return
    }

    if listData[to] != current {
      moveAction(IndexSet(integer: from), to > from ? to + 1 : to)
    }
  }

  public func dropUpdated(info: DropInfo) -> DropProposal? {
    DropProposal(operation: .move)
  }

  public func performDrop(info: DropInfo) -> Bool {
    current = nil
    return true
  }
}
