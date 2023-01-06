import Foundation

public struct Dapp: Codable, Equatable, Hashable {
  public let id: UUID
  public let name: String
  public let icon: String
  public let site: String
  public let type: String

  public init(
    id: UUID = UUID(), name: String, icon: String, site: String, type: String
  ) {
    self.id = id
    self.name = name
    self.icon = icon
    self.site = site
    self.type = type
  }

  public static let dappDefault = Dapp(
    id: UUID(),
    name: "",
    icon: "",
    site: "",
    type: ""
  )
}
