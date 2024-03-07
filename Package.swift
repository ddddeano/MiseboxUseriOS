// swift-tools-version:5.9
import PackageDescription

let package = Package(
    name: "MiseboxUseriOS",
    platforms: [
        .iOS(.v16)
    ],
    products: [
        .library(
            name: "MiseboxUseriOS",
            targets: ["MiseboxUseriOS"]),
    ],
    dependencies: [
        .package(url: "https://github.com/ddddeano/FirebaseiOSMisebox.git", from: "1.0.3"),
        .package(url: "https://github.com/ddddeano/misebox-ios-global-pkg", from: "1.0.4")
    ],
    targets: [
        .target(
            name: "MiseboxUseriOS",
            dependencies: [
                "FirebaseiOSMisebox",
                .product(name: "MiseboxiOSGlobal", package: "misebox-ios-global-pkg")
            ]
        ),
        .testTarget(
            name: "MiseboxUseriOSTests",
            dependencies: ["MiseboxUseriOS"]),
    ]
)
