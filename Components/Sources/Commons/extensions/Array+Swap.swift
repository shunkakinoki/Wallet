import Foundation

extension Array where Element: Equatable {
  public mutating func move(_ item: Element, to newIndex: Index) {
    if let index = firstIndex(of: item) {
      move(at: index, to: newIndex)
    }
  }
}

extension Array {
  public mutating func move(at index: Index, to newIndex: Index) {
    insert(remove(at: index), at: newIndex)
  }
}
