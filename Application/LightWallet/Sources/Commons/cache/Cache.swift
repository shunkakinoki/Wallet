import Foundation

public struct Cache<ValueType> {
  public typealias KeyType = String
  private class Wrapper<T>: NSObject {
    let value: T
    init(_ value: T) {
      self.value = value
      super.init()
    }
  }

  private let mapTable: NSMapTable<NSString, Wrapper<ValueType>>
  private let defaultKey = String(describing: Cache.self) + String(describing: ValueType.self)

  public init() {
    let mapTable = NSMapTable<NSString, Wrapper<ValueType>>(
      keyOptions: .strongMemory, valueOptions: .strongMemory
    )
    self.init(mapTable: mapTable)
  }

  private init(mapTable: NSMapTable<NSString, Wrapper<ValueType>>) {
    self.mapTable = mapTable
  }

  public func get() -> ValueType? {
    let wrappedKey = defaultKey as NSString
    guard let wrappedValue = mapTable.object(forKey: wrappedKey) else { return nil }
    return wrappedValue.value
  }

  public func get(with key: NSString) -> ValueType? {
    guard let wrappedValue = mapTable.object(forKey: key) else { return nil }
    return wrappedValue.value
  }

  public func set(_ obj: ValueType) {
    let wrappedKey = defaultKey as NSString
    let wrappedValue = Wrapper(obj)
    mapTable.setObject(wrappedValue, forKey: wrappedKey)
  }

  public func set(_ obj: ValueType, key: NSString) {
    let wrappedValue = Wrapper(obj)
    mapTable.setObject(wrappedValue, forKey: key)
  }
}
