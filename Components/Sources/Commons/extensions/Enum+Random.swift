import Foundation

extension CaseIterable {
  public static func random<G: RandomNumberGenerator>(using generator: inout G)
    -> Self.AllCases.Element
  {
    return Self.allCases.randomElement(using: &generator)!
  }

  public static func random() -> Self.AllCases.Element {
    var g = SystemRandomNumberGenerator()
    return Self.random(using: &g)
  }
}
