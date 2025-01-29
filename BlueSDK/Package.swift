// swift-tools-version: 6.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "BlueSDK",
    products: [
        // Products define the executables and libraries a package produces, making them visible to other packages.
        .library(
            name: "BlueSDK",
            targets: ["BlueSDK"]),
    ],
    dependencies: [
        .package(url: "https://github.com/mkrd/Swift-BigInt.git", .upToNextMajor(from: "2.0.0" ))
    ],
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        .target(
            name: "BlueSDK",
            dependencies: [
                .product(name: "BigNumber", package: "Swift-BigInt")
            ]
        ),
        .testTarget(
            name: "BlueSDKTests",
            dependencies: ["BlueSDK"]
        ),
    ]
)
