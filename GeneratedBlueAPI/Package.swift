// swift-tools-version:5.9

import PackageDescription

let package = Package(
  name: "GeneratedBlueAPI",
  platforms: [
    .iOS(.v12),
    .macOS(.v10_14),
    .tvOS(.v12),
    .watchOS(.v5),
  ],
  products: [
    .library(name: "GeneratedBlueAPI", targets: ["GeneratedBlueAPI"]),
  ],
  dependencies: [
    .package(url: "https://github.com/apollographql/apollo-ios", exact: "1.16.0"),
  ],
  targets: [
    .target(
      name: "GeneratedBlueAPI",
      dependencies: [
        .product(name: "ApolloAPI", package: "apollo-ios"),
      ],
      path: "./Sources"
    ),
  ]
)
