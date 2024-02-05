// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

// swift-tools-version:5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription
//
let package = Package(
    name: "MiseboxUseriOS",
    platforms: [
        .iOS(.v16) // Set the iOS version you want to support
    ],
    products: [
        // Products define the executables and libraries a package produces, making them visible to other packages.
        .library(
            name: "MiseboxUseriOS",
            targets: ["MiseboxUseriOS"]),
    ],
    dependencies: [
        .package(url: "https://github.com/ddddeano/FirebaseiOSMisebox.git", from: "1.0.0"), // Replace with the correct version
    ],
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        .target(
            name: "MiseboxUseriOS",
            dependencies: [
                "FirebaseiOSMisebox", // Add the dependency here
            ]
        ),
        .testTarget(
            name: "MiseboxUseriOSTests",
            dependencies: ["MiseboxUseriOS"]),
    ]
)
