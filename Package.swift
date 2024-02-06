// swift-tools-version:5.9
import PackageDescription

let package = Package(
    name: "MiseboxUseriOSPKG",
    platforms: [
        .iOS(.v16)
    ],
    products: [
        .library(
            name: "MiseboxUseriOSPKG",
            targets: ["MiseboxUseriOSPKG"]),
    ],
    dependencies: [
        .package(url: "https://github.com/ddddeano/FirebaseiOSMisebox.git", from: "1.0.3"),
        .package(url: "https://github.com/ddddeano/GlobalMiseboxiOS.git", from: "1.0.4")
    ],
    targets: [
        .target(
            name: "MiseboxUseriOSPKG",
            dependencies: [
                "FirebaseiOSMisebox",
                "GlobalMiseboxiOS"
            ]
        ),
        .testTarget(
            name: "MiseboxUseriOSPKGTTests",
            dependencies: ["MiseboxUseriOSPKG"]),
    ]
)
