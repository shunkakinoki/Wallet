import Foundation

public protocol NestedCodingKey: CodingKey {
  var nestedKeys: [String] { get }
}

@propertyWrapper
public struct NestedKey<T: Codable>: Codable {
  public var wrappedValue: T

  public init(wrappedValue: T) {
    self.wrappedValue = wrappedValue
  }

  public init(from decoder: Decoder) throws {
    let codingKey = decoder.codingPath.last!

    guard let key = codingKey as? NestedCodingKey else {
      throw DecodingError.keyNotFound(
        codingKey,
        .init(
          codingPath: decoder.codingPath,
          debugDescription: "CodingKeys must conform to NestedCodingKey"))
    }

    let last = key.nestedKeys.last!
    let container = try key.nestedKeys.dropFirst().dropLast().reduce(
      decoder.container(keyedBy: AnyCodingKey.self)
    ) { container, key in
      return try container.nestedContainer(keyedBy: AnyCodingKey.self, forKey: AnyCodingKey(key))
    }

    self.wrappedValue = try container.decode(T.self, forKey: AnyCodingKey(last))
  }

  public func encode(to encoder: Encoder) throws {
    let codingKey = encoder.codingPath.last!

    guard let key = codingKey as? NestedCodingKey else {
      throw EncodingError.invalidValue(
        codingKey,
        .init(
          codingPath: encoder.codingPath,
          debugDescription: "CodingKeys must conform to NestedCodingKey"))
    }

    let last = key.nestedKeys.last!
    var container = encoder.container(keyedBy: AnyCodingKey.self)

    for key in key.nestedKeys.dropFirst().dropLast() {
      container = container.nestedContainer(keyedBy: AnyCodingKey.self, forKey: .init(key))
    }

    try container.encode(wrappedValue, forKey: AnyCodingKey(last))
  }
}

extension NestedKey: Equatable where T: Equatable {}

extension KeyedDecodingContainer {
  public func decode<T>(_ type: NestedKey<T?>.Type, forKey key: KeyedDecodingContainer<K>.Key)
    throws -> NestedKey<T?>
  {
    return NestedKey<T?>(wrappedValue: try? decode(NestedKey<T>.self, forKey: key).wrappedValue)
  }
}

extension NestedCodingKey where Self: RawRepresentable, RawValue == String {
  public init?(stringValue: String) { self.init(rawValue: stringValue) }
  public init?(intValue: Int) { fatalError() }

  public var intValue: Int? { nil }
  public var stringValue: String { nestedKeys.first! }

  public var nestedKeys: [String] { rawValue.components(separatedBy: ".") }
}

public struct AnyCodingKey: CodingKey {
  public var stringValue: String
  public var intValue: Int?

  public init?(intValue: Int) {
    self.intValue = intValue
    self.stringValue = "\(intValue)"
  }
  public init?(stringValue: String) {
    self.intValue = nil
    self.stringValue = stringValue
  }
}

extension AnyCodingKey {
  init<T: CodingKey>(_ key: T) {
    self.stringValue = key.stringValue
    self.intValue = key.intValue
  }
  init(_ int: Int) {
    self.init(intValue: int)!
  }
  init(_ string: String) {
    self.init(stringValue: string)!
  }
}

extension AnyCodingKey: ExpressibleByStringLiteral {
  public init(stringLiteral value: String) {
    self.init(stringValue: value)!
  }
}

extension AnyCodingKey: ExpressibleByIntegerLiteral {
  public init(integerLiteral value: Int) {
    self.init(intValue: value)!
  }
}
