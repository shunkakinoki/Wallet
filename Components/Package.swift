// swift-tools-version: 5.5
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
  name: "Components",
  platforms: [.iOS(.v15)],
  products: [
    .library(
      name: "Core",
      targets: ["Main"]),
    .library(
      name: "Extension",
      targets: ["SafariExtension"]),
  ],
  dependencies: [
    .package(url: "https://github.com/SnapKit/SnapKit", from: "5.0.1"),
    .package(url: "https://github.com/SDWebImage/SDWebImage", from: "5.12.5"),
    .package(url: "https://github.com/SDWebImage/SDWebImageSwiftUI", from: "2.0.2"),
    .package(url: "https://github.com/SDWebImage/SDWebImageSVGCoder.git", from: "1.6.1"),
    .package(
      url: "https://github.com/socketio/socket.io-client-swift",
      .revision("a1ed825835a2d8c2555938e96557ccc05e4bebf3")),
    .package(url: "https://github.com/kean/Nuke", .branch("master")),
    .package(url: "https://github.com/krzyzanowskim/CryptoSwift", from: "1.5.1"),
    .package(url: "https://github.com/GigaBitcoin/secp256k1.swift", .branch("main")),
    .package(url: "https://github.com/attaswift/BigInt", from: "5.3.0"),
    .package(url: "https://github.com/zcash-hackworks/MnemonicSwift", from: "2.2.4"),
    .package(url: "https://github.com/ivanvorobei/SPAlert", .upToNextMajor(from: "4.2.0")),
    .package(url: "https://github.com/ivanvorobei/SPIndicator", .upToNextMajor(from: "1.6.0")),
  ],
  targets: [
    .target(
      name: "AddressServices",
      dependencies: [
        "Networking",
        "Session",
      ]),
    .target(
      name: "Commons",
      dependencies: [
        "SDWebImageSwiftUI",
        "CryptoSwift",
        "BigInt",
      ]),
    .testTarget(
      name: "CommonsTests",
      dependencies: [
        "Commons"
      ]),
    .target(
      name: "Domain",
      dependencies: [
        "Commons"
      ]),
    .target(name: "EthereumNetworking"),
    .target(
      name: "EthereumServices",
      dependencies: [
        "EthereumNetworking",
        "Domain",
        "Keychain",
      ]),
    .target(
      name: "Home",
      dependencies: [
        "AddressServices",
        "Commons",
        "SnapKit",
        "UIComponents",
        "Keychain",
        "Import",
        "Settings",
        "SPAlert",
        "SPIndicator",
        "TokenServices",
      ]),
    .target(
      name: "Import",
      dependencies: [
        "Keychain",
        "EthereumServices",
        "UIComponents",
      ]),
    .target(
      name: "Keychain",
      dependencies: [
        "Commons",
        "Domain",
        "MnemonicSwift",
        .product(name: "secp256k1", package: "secp256k1.swift"),
      ]),
    .testTarget(
      name: "KeychainTests",
      dependencies: [
        "Keychain",
        "Domain",
      ]),
    .target(
      name: "Main",
      dependencies: [
        "Home", "Onboarding", "Commons", "SnapKit", "Splash", "UIComponents", "Transaction",
      ]),
    .target(
      name: "Networking",
      dependencies: [
        .product(name: "SocketIO", package: "socket.io-client-swift"),
        "Commons",
      ]
    ),
    .target(
      name: "Onboarding",
      dependencies: [
        "Commons",
        "Import",
      ]),
    .target(
      name: "SafariExtension",
      dependencies: [
        "Keychain",
        "Session",
        "EthereumServices",
      ]),
    .testTarget(
      name: "SafariExtensionTests",
      dependencies: [
        "SafariExtension"
      ]),
    .target(
      name: "Session",
      dependencies: [
        "Commons",
        "Domain",
      ]),
    .target(
      name: "Settings",
      dependencies: [
        "Commons",
        "UIComponents",
        "Session",
        "SPAlert",
        "SPIndicator",
        "Keychain",
      ]),
    .target(
      name: "Splash",
      dependencies: [
        "Session",
        "SnapKit",
        "SDWebImageSVGCoder",
      ]),
    .target(
      name: "TokenServices",
      dependencies: [
        "Commons",
        "Networking",
        "Keychain",
        "Session",
      ]),
    .target(
      name: "TransactionServices",
      dependencies: [
        "Commons",
        "Networking",
        "Keychain",
        "Session",
      ]),
    .target(
      name: "Transaction",
      dependencies: [
        "Commons",
        "Home",
        "SDWebImageSwiftUI",
        "TransactionServices",
        "UIComponents",
      ]),
    .target(
      name: "UIComponents",
      dependencies: [
        "SnapKit",
        "SDWebImage",
        "Commons",
        "TokenServices",
        "TransactionServices",
        .product(name: "NukeUI", package: "Nuke"),
      ]),
  ]
)
