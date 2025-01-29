// swift-tools-version: 6.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "BlueAPI",
    products: [
        // Products define the executables and libraries a package produces, making them visible to other packages.
        .library(
            name: "BlueAPI",
            targets: ["BlueAPI"]),
    ],
    dependencies: [
        .package(
            url: "https://github.com/apollographql/apollo-ios.git",
            .upToNextMajor(from: "1.0.0")
        ),
        .package(path: "../BlueSDK"),
        .package(path: "../GeneratedBlueAPI"),

    ],
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        .target(
            name: "BlueAPI",
            dependencies: [
                .product(name: "Apollo", package:"apollo-ios"),
                .product(name: "ApolloAPI", package: "apollo-ios"),
                .product(name: "ApolloSQLite", package: "apollo-ios"),
                .product(name: "ApolloTestSupport", package: "apollo-ios"),
                .product(name: "GeneratedBlueAPI", package: "GeneratedBlueAPI"),
                .product(name: "BlueSDK", package: "BlueSDK")
            ]
        ),
        .testTarget(
            name: "BlueAPITests",
            dependencies: ["BlueAPI"]
        ),
    ]
)
