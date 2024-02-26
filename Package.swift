// swift-tools-version:5.9
import PackageDescription

let package = Package(
    name: "MiseboxiOS",
    platforms: [
        .iOS(.v16)
    ],
    products: [
        .library(
            name: "MiseboxiOS",
            targets: ["MiseboxiOS"]),
    ],
    dependencies: [
        .package(url: "https://github.com/ddddeano/FirebaseiOSMisebox.git", from: "1.0.3"),
        .package(url: "https://github.com/ddddeano/misebox-ios-global-pkg", from: "1.0.4")
    ],
    targets: [
        .target(
            name: "MiseboxiOS",
            dependencies: [
                "FirebaseiOSMisebox",
                .product(name: "MiseboxiOSGlobal", package: "misebox-ios-global-pkg")
            ]
        ),
        .testTarget(
            name: "MiseboxiOSTests",
            dependencies: ["MiseboxiOS"]),
    ]
)
