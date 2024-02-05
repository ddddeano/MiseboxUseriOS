// swift-tools-version: 5.9

import PackageDescription

let package = Package(
    name: "MiseboxUseriOS",
    platforms: [
        .iOS(.v16) // Specify iOS 16 as the minimum deployment target
    ],
    products: [
        .library(
            name: "MiseboxUseriOS",
            targets: ["MiseboxUseriOS"]),
    ],
    dependencies: [
        .package(url: "https://github.com/ddddeano/FirebaseiOSMisebox.git", from: "1.0.0"),
        // Add other package dependencies here if needed
    ],
    targets: [
        .target(
            name: "MiseboxUseriOS",
            dependencies: [
                "FirebaseiOSMisebox"
            ],
            path: "Sources/MiseboxUseriOS", // Optional: Custom path
            exclude: ["ExcludedFile.swift"], // Optional: Exclude files
            sources: ["IncludeThisFolderOrFile"], // Optional: Specific sources
            resources: [.process("Resources")] // Optional: Resources
        ),
        .testTarget(
            name: "MiseboxUseriOSTests",
            dependencies: ["MiseboxUseriOS"]),
    ]
)

