// swift-tools-version: 6.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "MorphoCore",
    products: [
        // Products define the executables and libraries a package produces, making them visible to other packages.
        .library(
            name: "MorphoCore",
            targets: ["MorphoCore"]),
    ],
    dependencies: [
        .package(path: "../BlueSDK"),
        .package(path: "../BlueAPI")
    ],
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        .target(
            name: "MorphoCore",
            dependencies: [
                .product(name: "BlueSDK", package: "BlueSDK"),
                .product(name: "BlueAPI", package: "BlueAPI")
            ]
        ),
            
        .testTarget(
            name: "MorphoCoreTests",
            dependencies: ["MorphoCore"]
        ),
    ]
)
