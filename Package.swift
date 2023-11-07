// swift-tools-version: 5.8
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "PocketlabSDK",
    platforms: [.iOS(.v16)],
    products: [
        // Products define the executables and libraries a package produces, making them visible to other packages.
        .library(
            name: "PocketlabSDK",
            targets: ["PocketlabSDK"]),
    ],
    dependencies: [
            // Add dependencies if your SDK uses other packages.
        ],
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        .target(
            name: "PocketlabSDK"),
        .testTarget(
            name: "PocketlabSDKTests",
            dependencies: ["PocketlabSDK"]),
    ]
)
