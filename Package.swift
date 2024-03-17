// swift-tools-version:5.9
import PackageDescription

let package = Package(
    name: "MiseboxUseriOS_PKG",
    platforms: [
        .iOS(.v16)
    ],
    products: [
        .library(
            name: "MiseboxUseriOS_PKG",
            targets: ["MiseboxUseriOS_PKG"]),
    ],
    dependencies: [
        .package(url: "https://github.com/ddddeano/FirebaseiOSMisebox.git", from: "1.0.3"),
        .package(url: "https://github.com/ddddeano/misebox-ios-global-pkg", from: "1.0.4")
    ],
    targets: [
        .target(
            name: "MiseboxUseriOS_PKG",
            dependencies: [
                "FirebaseiOSMisebox",
                .product(name: "MiseboxiOSGlobal", package: "misebox-ios-global-pkg")
            ]
        ),
    ]
)
